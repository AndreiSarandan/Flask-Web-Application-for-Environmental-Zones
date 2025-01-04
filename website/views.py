from flask import Blueprint, render_template, flash,request,redirect, url_for
from flask_login import login_required, current_user
from sqlalchemy.exc import IntegrityError
from flask import jsonify, get_flashed_messages
from .check_functions import *
from sqlalchemy import exists
import json


views = Blueprint('views', __name__) 
from . import db


# Load secrets
with open('secrets.json') as f: 
    secrets = json.load(f)

@views.context_processor
def inject_api_key():
    #these variables will be available in all HTML templates
    return {'WAQI_API_KEY': secrets.get('WAQI_API_KEY'), 'GOOGLE_API_KEY':secrets.get('GOOGLE_API_KEY'), 'OPEN_CAGE_API_KEY': secrets.get('OPEN_CAGE_API_KEY') }


@views.route('/', methods=['GET','POST'])
# @login_required #can only access the home page if logged in
def home():

    from .models import Zone 
    countries_with_lez =Zone.get_countries()
    cities_by_country=Zone.get_countries_and_cities()


    return render_template("home.html", user = current_user, countries_with_lez=countries_with_lez, cities_by_country=cities_by_country)


@views.route('/cities')
def get_cities():
  # Assuming you have a function to fetch cities with country information
  cities = Zone.query.with_entities(Zone.city, Zone.country).distinct().all()  # Include country field
  city_data = []
  for city in cities:
    city_data.append({'city': city[0], 'country': city[1]})  # Create dictionary with city and country
  return jsonify({'cities': city_data})


@views.route('/pollution', methods=['GET','POST'])
def polution():

    return render_template("pollution.html", user = current_user)


@views.route('/unauthorized')
def unauthorized():
    return "You are not authorized to access this page."


@views.route('/admin_dashboard')
@login_required
def admin_dashboard():
    from .models import ZoneTemporaryData
    if current_user.is_authenticated and current_user.is_admin:
        # Perform a join operation to fetch data from both tables
        combined_data = db.session.query(Zone, ZoneTemporaryData).\
            filter(Zone.id == ZoneTemporaryData.zone_id).all()

        # Pass the combined data to the template
        return render_template("admin_dashboard.html", user=current_user, combined_data=combined_data)
    else:
        return "You are not authorized to access this page."
    
    
@views.route('/update', methods=['POST'])
@login_required
def update_zone_table():
    data = request.get_json()  # Get the JSON data from the request body
    from .models import Zone, ZoneTemporaryData
    # Iterate over the data and update each entry
    try:
        for entry in data:
            zone_id = entry.get('id')
            if not zone_id:
                return jsonify({'message': 'ID is required for all entries.'}), 400

            zone = Zone.query.get(zone_id)
            if zone:
                # Update existing Zone object if it exists
                zone.country = entry.get('country')
                zone.city = entry.get('city')
                zone.registration_class = entry.get('registration_class')
                zone.minimum_diesel = entry.get('minimum_diesel')
                zone.minimum_petrol = entry.get('minimum_petrol')
                zone.fines = entry.get('fines')
                zone.registration_type = entry.get('registration_type')
                zone.registration_validity = entry.get('registration_validity')
                zone.required_registration = entry.get('required_registration')
                zone.exception_country = entry.get('exception_country')
                zone.official_page = entry.get('official_page')
                zone.description = entry.get('description')
                zone.city_alias = entry.get('city_alias')

            else:
                # Create a new Zone object if it doesn't exist
                zone = Zone(
                    id=zone_id,  # Assign the provided ID
                    country=entry.get('country'),
                    city=entry.get('city'),
                    registration_class=entry.get('registration_class'),
                    minimum_diesel=entry.get('minimum_diesel'),
                    minimum_petrol=entry.get('minimum_petrol'),
                    fines=entry.get('fines'),
                    registration_type=entry.get('registration_type'),
                    registration_validity=entry.get('registration_validity'),
                    required_registration=entry.get('required_registration'),
                    exception_country=entry.get('exception_country'),
                    official_page=entry.get('official_page'),
                    description=entry.get('description'),
                    city_alias = entry.get('city_alias')

                )
                db.session.add(zone)

            # Update or create associated temporary zone data
            temporary_data = ZoneTemporaryData.query.filter_by(zone_id=zone_id).first()
            if temporary_data:
                temporary_data.temporary_data = entry.get('temporary_data')
                temporary_data.tp_lez_start = entry.get('tp_lez_start')
                temporary_data.tp_lez_end = entry.get('tp_lez_end')
                temporary_data.tp_minimum_diesel = entry.get('tp_minimum_diesel')
                temporary_data.tp_minimum_petrol = entry.get('tp_minimum_petrol')
            else:
                temporary_data = ZoneTemporaryData(
                    zone_id=zone_id,
                    country=entry.get('country'),
                    city=entry.get('city'),
                    temporary_data=entry.get('temporary_data'),
                    tp_lez_start=entry.get('tp_lez_start'),
                    tp_lez_end=entry.get('tp_lez_end'),
                    tp_minimum_diesel=entry.get('tp_minimum_diesel'),
                    tp_minimum_petrol=entry.get('tp_minimum_petrol')
                )
                db.session.add(temporary_data)

        # Commit the changes to the database after all entries are processed
        db.session.commit()
        return jsonify({'message': 'Zone table updated successfully.'}), 200

    except IntegrityError as e:
        db.session.rollback()
        print(e)
        return jsonify({'message': 'An error occurred with the database integrity.'}), 400

    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify({'message': 'An unexpected error occurred.'}), 500




@views.route('/info')
def general_info():
    from .models import Zone 
    countries=Zone.query.with_entities(Zone.country).distinct().all()
    countries_with_lez = [country[0].strip("()''") for country in countries]


    from .models import Zone 
    countries_with_lez =Zone.get_countries()
    cities_by_country=Zone.get_countries_and_cities()

    print("countries: ",countries_with_lez)
    return render_template("info.html", user = current_user, countries_with_lez=countries_with_lez,cities_by_country=cities_by_country)


@views.route('/info/<country>')
def country_info(country):
    country=country.upper()
    from .models import Zone 
    results = Zone.query.filter_by(country=country).with_entities(Zone.city, Zone.required_registration).order_by(Zone.city.asc()).all()
    cities = [result[0] for result in results]
    registrations = [result[1] for result in results]
    print(registrations)

    print(country)
    countries_with_lez =Zone.get_countries()
    cities_by_country=Zone.get_countries_and_cities()
    fines=Zone.get_fines(cities[0])

    print(f"cities of {country}: ", cities)


    return render_template(f"/countries_templates/info-{country.lower()}.html", user=current_user,country=country, cities=cities, registrations=registrations, countries_with_lez=countries_with_lez, cities_by_country=cities_by_country,fines=fines, zip=zip)

@views.route('/my-profile', methods=['GET','POST'])
@login_required #can only access the home page if logged in
def my_profile():
    countries_with_lez =Zone.get_countries()
    cities_by_country=Zone.get_countries_and_cities()
    return render_template("my_profile2.html", user = current_user,countries_with_lez=countries_with_lez,cities_by_country=cities_by_country)


@views.route('/new-car',methods=['POST','GET'])
@login_required
def new_car():
    from .models import Zone
    countries_with_lez =Zone.get_countries()
    cities_by_country=Zone.get_countries_and_cities()
    if request.method== 'POST':
        print("Form Data:", request.form)
        owner_id=current_user.id
        brand=request.form.get('brand')
        model=request.form.get('model')
        year=request.form.get('year')
        fuel_type=request.form.get('fuel_type')
        euro_standard=request.form.get('euro_standard')
        registration_country=request.form.get('registration_country')
        has_dpf=request.form.get('has_dpf')
        if has_dpf =='on':
            dpf=True
        else:
            dpf=False
        

        #registrations
        belgium_reg=request.form.get('Belgium_registration')
        bulgaria_reg=request.form.get('Bulgaria_registration')
        denmark_reg=request.form.get('Denmark_registration')
        france_reg=request.form.get('France_registration')
        germany_reg=request.form.get('Germany_registration')
        greece_reg=request.form.get('Greece_registration')
        netherlands_reg=request.form.get('Netherlands_registration')
        norway_reg=request.form.get('Norway_registration')
        poland_reg=request.form.get('Poland_registration')
        spain_reg=request.form.get('Spain_registration')
        uk_reg=request.form.get('United Kingdom_registration')



        if brand=='':
            flash('Please select car brand.', category='Error')
        elif model=='':
            flash("Please select car model.", category='Error')
        elif year=='':
            flash('Please select vehicle fabrication year.', category='Error')
        elif fuel_type=='':
            flash('Please select vehicle fuel type.', category='Error')
        elif euro_standard=='':
            flash('Please select vehicle Euro standard.', category='Error')
        elif registration_country=='':
            flash('Please select vehicle registration conutry.', category='Error')     
        else:
            from .models import Car
            new_car = Car(owner_id,brand,model,year,fuel_type,euro_standard,dpf,registration_country,belgium_reg,bulgaria_reg,denmark_reg,france_reg,germany_reg,greece_reg,netherlands_reg,norway_reg,poland_reg,spain_reg,uk_reg)
            db.session.add(new_car)
            db.session.commit()
            flash('Car added. ', category='Success')
            return render_template('my_profile2.html', user=current_user)


    return render_template("new_car3.html", user = current_user, countries_with_lez=countries_with_lez,cities_by_country=cities_by_country)


@views.route('delete/<int:car_id>')
@login_required
def delete(car_id):
    from .models import Car
    car_to_delete = Car.query.get_or_404(car_id)

    try:
        db.session.delete(car_to_delete)
        db.session.commit()
        return redirect(url_for('views.my_profile')) 
    except:
        return "Error in deleteting the car. "
    


@views.route('delete-zone/<int:zone_id>')
@login_required
def delete_zone(zone_id):
    from .models import Zone, ZoneTemporaryData
    zone_to_delete = Zone.query.get_or_404(zone_id)

    try:
        db.session.delete(zone_to_delete)
        db.session.commit()
        
        # Redirect to admin dashboard after deletion
        return redirect(url_for('views.admin_dashboard')) 
    
    except Exception as e:
        db.session.rollback()
        print(e)
        return "Error in deleting the zone."


@views.route('/edit/<int:car_id>', methods=['POST','GET'])
@login_required
def edit(car_id):
    from .models import Car,Zone
    countries_with_lez =Zone.get_countries()
    cities_by_country=Zone.get_countries_and_cities()
    car = Car.query.get_or_404(car_id)
    car_data = {
        'owner_id': car.owner_id,
        'brand': car.brand,
        'model': car.model,
        'year': car.year,
        'fuel_type': car.fuel_type,
        'euro_standard': car.euro_standard,
        'dpf':car.dpf,
        'registration_country': car.registration_country,
        'belgium_reg': car.belgium_registrations,
        'bulgaria_reg': car.bulgaria_registrations,
        'denmark_reg': car.denmark_registrations,
        'france_reg': car.france_registrations,
        'germany_reg': car.germany_registrations,
        'greece_reg': car.greece_registrations,
        'netherlands_reg': car.netherlands_registrations,
        'norway_reg': car.norway_registrations,
        'poland_reg': car.poland_registrations,
        'spain_reg': car.spain_registrations,
        'uk_reg': car.united_kingdom_registrations
        
    }

    # Convert the dictionary to JSON format
    car_json = json.dumps(car_data)

    print(car)
    if request.method=='POST':
        print(request.form)
        car.brand = request.form.get('brand')
        car.model = request.form.get('model')
        car.year = request.form.get('year')
        car.fuel_type = request.form.get('fuel_type')
        car.euro_standard = request.form.get('euro_standard')
        car.registration_country = request.form.get('registration_country')
        car.has_dpf=request.form.get('has_dpf')
        if car.has_dpf =='on':
            car.dpf=True
        else:
            car.dpf=False
        

        #registrations
        car.belgium_registrations=request.form.get('Belgium_registration')
        car.bulgaria_registrations=request.form.get('Bulgaria_registration')
        car.denmark_registrations=request.form.get('Denmark_registration')
        car.france_registrations=request.form.get('France_registration')
        car.germany_registrations=request.form.get('Germany_registration')
        car.greece_registrations=request.form.get('Greece_registration')
        car.netherlands_registrations=request.form.get('Netherlands_registration')
        car.norway_registrations=request.form.get('Norway_registration')
        car.poland_registrations=request.form.get('Poland_registration')
        car.spain_registrations=request.form.get('Spain_registration')
        car.uk_registrations=request.form.get('United Kingdom_registration')  

        try:
            db.session.commit()
            # return render_template('my_profile2.html',user=current_user)
            return redirect(url_for('views.my_profile')) 
        except:
            return "There was a problem updating car details. "
    else:
        return render_template('edit_car2.html',car=car,user=current_user, car_json=car_json,countries_with_lez=countries_with_lez,cities_by_country=cities_by_country)
    
@views.route('delete_route/<int:route_id>')
@login_required
def delete_route(route_id):
    from .models import SavedRoute
    route_to_delete = SavedRoute.query.get_or_404(route_id)

    try:
        db.session.delete(route_to_delete)
        db.session.commit()
        return render_template('my_profile2.html', user=current_user)
    except:
        return "Error in deleteting the route. "
    


@views.route('/get-new-vehicle-info', methods=['POST'])
@login_required
def get_new_vehicle_info():
    print("Checking Eligibility of NEW vehicle. ")

    from .models import get_registration_class

    # Get vehicle information from the request data
    vehicle_data = request.get_json()
    print(vehicle_data)
    navigation_country = vehicle_data.get('navigationCountry')

    # Extract vehicle data
    year = vehicle_data.get('year')
    fuel_type = vehicle_data.get('fuelType')
    euro_standard = vehicle_data.get('euroStandard')
    registration_country = vehicle_data.get('registrationCountry')
    print("registration country", registration_country)
    registration_date = vehicle_data.get('registration_date') #not applicable in all cases
    print("registration date", registration_date)
    has_dpf = vehicle_data.get('hasDpf')

    # Perform eligibility checks
    car_data = {
        'year': year,
        'fuel_type': fuel_type,
        'euro_standard': euro_standard,
        'registration_country': registration_country,
        'registration_date': registration_date,
        'has_dpf':has_dpf
    }

    # Get the appropriate registration class based on the navigation country
    registration_class = get_registration_class(navigation_country)
    if registration_class:
        # Instantiate the registration class
        registration_instance = registration_class()
        if navigation_country == "Poland":
            eligible_registration = registration_instance.find_best_registration_badge(fuel_type, euro_standard,registration_date)
        elif navigation_country == "Germany":
            eligible_registration=registration_instance.find_best_registration_badge(fuel_type,euro_standard,has_dpf)
        else:
            # Call the method to find the best registration badge
            eligible_registration = registration_instance.find_best_registration_badge(fuel_type, euro_standard)
    

        if eligible_registration:
            car_data['eligible_registration'] = eligible_registration.name
            car_data['eligible_registration_image'] = eligible_registration.image_url
            car_data['eligible_registration_result'] = eligible_registration.result
            car_data['eligible_registration_description'] = eligible_registration.description
        else:
            car_data['eligible_registration'] = None
            car_data['eligible_registration_result'] = "Error"

    else:
        car_data['eligible_registration'] = None
    return jsonify(car_data)


#eligibility check for selected vehicle
@views.route('/get-vehicle-info/<car_id>', methods=['POST','GET'])
@login_required
def get_vehicle_info(car_id):
    if request.method =='POST':
        print("Checking Eligibility of selected vehicle. ")
        from .models import get_registration_class
        car = Car.query.filter_by(id=car_id).first()
        navigation_country=request.form.get('navigation-country')
        selected_car = request.form.get('selected-car')
        registration_date=request.form.get('registration_date')

        print(navigation_country)
        print(car)
        
        if car:
            car_data = {
                'year': car.year,
                'fuel_type': car.fuel_type,
                'euro_standard': car.euro_standard,
                'registration_country': car.registration_country,
                'has_dpf':car.dpf
                }
        
            # user_car = Car(**car_data)  # Assign a value to user_car
            registration_class = get_registration_class(navigation_country)

            if registration_class:
                # Instantiate the registration class
                registration_instance = registration_class()           
                # Call the method to find the best registration badge
                if navigation_country == "Poland":
                    eligible_registration = registration_instance.find_best_registration_badge(car.fuel_type, car.euro_standard,registration_date)
                elif navigation_country == "Germany":
                    eligible_registration=registration_instance.find_best_registration_badge(car.fuel_type,car.euro_standard,car.dpf)
                else:
                    # Call the method to find the best registration badge
                    eligible_registration = registration_instance.find_best_registration_badge(car.fuel_type, car.euro_standard)
                # eligible_registration = registration_instance.find_best_registration_badge(car.fuel_type, car.euro_standard)
                print(eligible_registration)
                car_data['eligible_registration'] = eligible_registration.name
                car_data['eligible_registration_image'] = eligible_registration.image_url
                car_data['eligible_registration_result'] = eligible_registration.result
                car_data['eligible_registration_description'] = eligible_registration.description

                # car_data['eligible_registration_name']=eligible_registration.name
            else:
                car_data['eligible_registration'] = None
            print(car_data)
            return jsonify(car_data)
        else:
            return jsonify({'error': 'Vehicle information not found'})



@views.route('/eligibility-check',methods=['POST','GET'])
@login_required
def eligibility_check():
    countries_with_lez =Zone.get_countries()
    cities_by_country=Zone.get_countries_and_cities()
    return render_template('eligibility_check3.html',user=current_user,countries_with_lez=countries_with_lez,cities_by_country=cities_by_country)



@views.route('/save-route', methods=['POST','GET'])
@login_required
def save_route():

    from .models import SavedRoute
    # destinations_text=[]
    car=request.form.get('selected-car')
    destinations=request.form.get('destinations')
    print(destinations)
    destinations_text = ' -> '.join(json.loads(destinations))

    route=SavedRoute(current_user.id,destinations,destinations_text)
    db.session.add(route)
    db.session.commit()
    print("Route added successfully!")

    return destinations


@views.route('/maps', methods=['POST', 'GET'])
@login_required
def navigation():
    from .models import Zone,SavedRoute

    countries_with_lez =Zone.get_countries()
    cities_by_country=Zone.get_countries_and_cities()

    # Store notification data in dictionary
    notification_data={}
    saved_routes = SavedRoute.query.filter_by(owner_id=current_user.id).all()

    if request.method == 'POST':
        destinations = request.form.get('destinations')
        selected_car_id = request.form.get('selected-car')
        short_address = request.form.get('cityCountryData')
        time_info=request.form.get('timeInfo')
        selected_car_reg_date=request.form.get('selected-car-registration-date')

          # Parse short_address from JSON string to a list of dictionaries
        try:
            short_address_list = json.loads(short_address)
        except json.JSONDecodeError:
            print('Error: Unable to parse short_address. Invalid JSON format.')
            short_address_list = []
            
        print(request.form)
        print(selected_car_reg_date)
        if selected_car_id:
            print(selected_car_id)
            selected_car = Car.query.get(selected_car_id)
            if selected_car:
                car_data = {
                    'owner_id': selected_car.owner_id,
                    'brand': selected_car.brand,
                    'model': selected_car.model,
                    'year': selected_car.year,
                    'fuel_type': selected_car.fuel_type,
                    'euro_standard': selected_car.euro_standard,
                    'registration_country': selected_car.registration_country,
                    'belgium_registrations': selected_car.belgium_registrations,
                    'bulgaria_registrations': selected_car.bulgaria_registrations,
                    'denmark_registrations': selected_car.denmark_registrations,
                    'france_registrations': selected_car.france_registrations,
                    'germany_registrations': selected_car.germany_registrations,
                    'greece_registrations': selected_car.greece_registrations,
                    'netherlands_registrations': selected_car.netherlands_registrations,
                    'poland_registrations': selected_car.poland_registrations,
                    'spain_registrations': selected_car.spain_registrations,
                    'united_kingdom_registrations': selected_car.united_kingdom_registrations
                }

                user_car = Car(**car_data)  # Assign a value to user_car
                print(user_car.brand, user_car.model)

                country_functions = {
                    'France': check_france,
                    'Belgium': check_belgium,
                    'Denmark': check_denmark,
                    'Germany': check_germany,
                    'Italy': check_italy,
                    'Netherlands': check_netherlands,
                    'United Kingdom': check_uk,
                    'UK': check_uk,
                    'Bulgaria': check_bulgaria,
                    'Hungary': check_hungary,
                    'Poland': check_poland,
                    'Portugal': check_portugal,
                    'Spain': check_spain,
                }

                for item in short_address_list:
                    country = item['country']
                    city = item['city']
                    if 'startTime' in item and 'endTime' in item:
                        # Access startTime and endTime values
                        start_time = item['startTime']
                        end_time = item['endTime']
                        print(f"{city} Start time: {start_time}")
                        print(f"{city} End time: {end_time}")
                    else:
                        start_time="None"
                        end_time="None"

                        

                    if country in country_functions:
                        if country == 'Poland':
                            check_result = country_functions[country](city, selected_car,start_time,end_time,selected_car_reg_date)
                        else:
                            check_result = country_functions[country](city, selected_car,start_time,end_time)
                        print(check_result)

                    else:
                        check_result= {
                            'notification_type': 'success-no-lez',
                            'notification_msg': f'There are no LEZs in {country}.',
                            }
                        
                    #conditional check for city_alias call
                    zone = Zone.query.filter(Zone.city_alias.ilike(f'%{city}%')).first()
                    if zone:
                            city = zone.city 

                    city_official_page = Zone.get_official_page(city)    
                    city_fines =f'Penalties for not complying to the regulations: {Zone.get_fines(city)}.'
                    city_info_for_temp=Zone.get_temporary_data(city)
                    city_required_registration_type=Zone.get_registration_type(city)

                    notification_data[city] = {
                        'country':country,
                        'notification_type': check_result['notification_type'],
                        'notification_msg': check_result['notification_msg'],
                        'city_official_page':city_official_page,
                        'city_required_registration_type':city_required_registration_type,
                        'city_fines':city_fines,
                        'city_info_for_temp':city_info_for_temp
                    }

                notification_data_json = json.dumps(notification_data)
                print(notification_data_json)
                print("time info: ", time_info)
                # return notification_data_json
                return jsonify(notification_data) 

        return render_template("maps-test.html", user=current_user, user_car=user_car,saved_routes=saved_routes, countries_with_lez=countries_with_lez,cities_by_country=cities_by_country)
    return render_template("maps-test.html", user=current_user,saved_routes=saved_routes,countries_with_lez=countries_with_lez,cities_by_country=cities_by_country)

