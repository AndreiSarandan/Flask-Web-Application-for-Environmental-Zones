from .models import Zone, Car
import requests
from datetime import datetime
from flask import jsonify
from functools import wraps
from flask import session, redirect, url_for
from sqlalchemy import or_

def getAQI(city):
    apiUrl = 'https://api.waqi.info/feed/' + city + '/?token=82645b03feba4f3384606a8471f00510abc10c37' 
    response = requests.get(apiUrl)
    if response.status_code == 200:
        data = response.json()
        aqi_value = data.get('data', {}).get('aqi')
        return aqi_value
    else:
        print('Failed to get AQI value from API:', response.status_code)
        return None

def check_france(city,selected_car, start_time=None, end_time=None, selected_car_reg_date=None):
    print("-> executing check_france()")
    zone = Zone.query.filter_by(city=city).first()
    if zone:
            # If the city exists, create an object with its values
            zone_object = {
                'id': zone.id,
                'country': zone.country,
                'city': zone.city,
                'registration_class': zone.registration_class,
                'minimum_diesel': zone.minimum_diesel,
                'minimum_petrol': zone.minimum_petrol,
                'fines': zone.fines,
                'registration_type': zone.registration_type,
                'registration_validity': zone.registration_validity,
                'required_registration': zone.required_registration,
                'exception_country': zone.exception_country,
                'description': zone.description
            }
            lez = Zone(**zone_object)

            if selected_car.france_registrations and int(selected_car.france_registrations[-1]) <= int(lez.required_registration[-1]):
                selected_car.france_registrations=selected_car.france_registrations.replace("Crit Air", "Crit'Air")
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'You are allowed to drive in {lez.city} LEZ. Your car has {selected_car.france_registrations} and {lez.required_registration} is required.',
                }
                return (response)

            else:
                if selected_car.france_registrations == None:
                    response = {
                    'notification_type': 'error',
                    'notification_msg': f'You are NOT allowed to drive in {lez.city} LEZ. Your car has no Crit\'Air registration but {lez.required_registration} is required.',
                }
                else:
                    selected_car.france_registrations=selected_car.france_registrations.replace("Crit Air", "Crit'Air")

                    response = {
                        'notification_type': 'error',
                        'notification_msg': f'You are NOT allowed to drive in {lez.city} LEZ. Your car has {selected_car.france_registrations} but {lez.required_registration} is required.',
                    }
                return (response)
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)

    
def check_germany(city,selected_car, start_time=None, end_time=None, selected_car_reg_date=None):
    print("-> executing check_germany()")
    zone = Zone.query.filter_by(city=city).first()
    if zone:
            # If the city exists, create an object with its values
            zone_object = {
                'id': zone.id,
                'country': zone.country,
                'city': zone.city,
                'registration_class': zone.registration_class,
                'minimum_diesel': zone.minimum_diesel,
                'minimum_petrol': zone.minimum_petrol,
                'fines': zone.fines,
                'registration_type': zone.registration_type,
                'registration_validity': zone.registration_validity,
                'required_registration': zone.required_registration,
                'exception_country': zone.exception_country,
                'description': zone.description
            }
            lez = Zone(**zone_object)
            
            if selected_car.germany_registrations and int(selected_car.germany_registrations[-1]) >= int(lez.required_registration[-1]):
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'You are allowed to drive in {lez.city} LEZ. Your car has {selected_car.germany_registrations} and {lez.required_registration} is required.',
                }
                return (response)
        
            else:
                response = {
                    'notification_type': 'error',
                    'notification_msg': f'You are NOT allowed to drive in {lez.city} LEZ. Your car has {selected_car.germany_registrations} but {lez.required_registration} is required.',
                }
                return (response)
        
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)
    

def check_belgium(city,selected_car, start_time=None, end_time=None):
    print("-> executing check_belgium()")
    # zone = Zone.query.filter_by(city=city).first()
    zone = Zone.query.filter(Zone.city.ilike(f'%{city}%')).first()

    if zone:
            # If the city exists, create an object with its values
            zone_object = {
                'id': zone.id,
                'country': zone.country,
                'city': zone.city,
                'registration_class': zone.registration_class,
                'minimum_diesel': zone.minimum_diesel,
                'minimum_petrol': zone.minimum_petrol,
                'required_registration': zone.required_registration,
                'exception_country':zone.exception_country

            }
            lez = Zone(**zone_object)
            if selected_car.registration_country in lez.exception_country:
                if selected_car.fuel_type == "DIESEL":
                    if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel):
                        response = {
                            'notification_type': 'success',
                            'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Vehicles registered in {lez.exception_country} do not require any additional registration but only Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol vehicles are allowed.',
                        }
                        return (response)
                    else:
                        response = {
                            'notification_type': 'error',
                            'notification_msg': f'Selected vehicle is NOT allowed in {city} LEZ. Vehicles registered in {lez.exception_country} do not require any additional registration but only Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol vehicles are allowed.',
                        }
                        return (response)
                elif selected_car.fuel_type=="ELECTRIC":
                        response = {
                            'notification_type': 'success',
                            'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Vehicles registered in {lez.exception_country} do not require any additional registration. Electric vehicles are allowed.',
                        }
                        return (response)

                else:
                    if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol):
                        response = {
                            'notification_type': 'success',
                            'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Vehicles registered in {lez.exception_country} do not require any additional registration but only Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol vehicles are allowed.',
                        }
                        return (response)
                    else:
                        response = {
                            'notification_type': 'error',
                            'notification_msg': f'Selected vehicle is NOT allowed in {city} LEZ. Vehicles registered in {lez.exception_country} do not require any additional registration but only Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol vehicles are allowed.',
                        }
                        return (response)

            else :
                if city in str(selected_car.belgium_registrations):
                    response = {
                        'notification_type': 'success',
                        'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Selected vehicle has digital {lez.required_registration} registration.',
                    }
                    return (response)
                else:
                    response = {
                        'notification_type': 'error',
                        'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Vehicles registered outside {lez.exception_country} require digital {lez.required_registration} registration.',
                    }
                    return (response)
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)
     

def check_denmark(city, selected_car, start_time=None, end_time=None):
    print("-> executing check_denmark()")
    zone = Zone.query.filter_by(city=city).first()
    if zone:
            # If the city exists, create an object with its values
            zone_object = {
                'id': zone.id,
                'country': zone.country,
                'city': zone.city,
                'registration_class': zone.registration_class,
                'minimum_diesel': zone.minimum_diesel,
                'minimum_petrol': zone.minimum_petrol,
                'required_registration': zone.required_registration,
                'exception_country':zone.exception_country
            }
            lez = Zone(**zone_object)
            if selected_car.registration_country in lez.exception_country:
                if selected_car.fuel_type == "DIESEL":
                    if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel):
                        response = {
                            'notification_type': 'success',
                            'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Vehicles registered in {lez.exception_country} do not require any additional registration but only Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol vehicles are allowed.',
                        }
                        return (response)
                    else:
                        response = {
                            'notification_type': 'error',
                            'notification_msg': f'Selected vehicle is NOT allowed in {city} LEZ. Vehicles registered in {lez.exception_country} do not require any additional registration but only Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol vehicles are allowed.',
                        }
                        return (response)
                elif selected_car.fuel_type=="ELECTRIC":
                        response = {
                            'notification_type': 'success',
                            'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Vehicles registered in {lez.exception_country} do not require any additional registration. Electric vehicles are allowed.',
                        }
                        return (response)

                else:
                    if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol):
                        response = {
                            'notification_type': 'success',
                            'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Vehicles registered in {lez.exception_country} do not require any additional registration but only Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol vehicles are allowed.',
                        }
                        return (response)
                    else:
                        response = {
                            'notification_type': 'error',
                            'notification_msg': f'Selected vehicle is NOT allowed in {city} LEZ. Vehicles registered in {lez.exception_country} do not require any additional registration but only Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol vehicles are allowed.',
                        }
                        return (response)

            else :
                if city in str(selected_car.denmark_registrations):
                    response = {
                        'notification_type': 'success',
                        'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Selected vehicle has digital {lez.required_registration} registration.',
                    }
                    return (response)
                else:
                    response = {
                        'notification_type': 'error',
                        'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Vehicles registered outside {lez.exception_country} require digital {lez.required_registration} registration.',
                    }
                    return (response)
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)
    



def check_uk(city, selected_car, start_time=None, end_time=None):
    print("-> executing check_uk()")
    zone = Zone.query.filter_by(city=city).first()
    if zone:
        # If the city exists, create an object with its values
        zone_object = {
                'id': zone.id,
                'country': zone.country,
                'city': zone.city,
                'registration_class': zone.registration_class,
                'minimum_diesel': zone.minimum_diesel,
                'minimum_petrol': zone.minimum_petrol,
                'fines': zone.fines,
                'registration_type': zone.registration_type,
                'registration_validity': zone.registration_validity,
                'required_registration': zone.required_registration,
                'exception_country': zone.exception_country,
                'description': zone.description
            }
        lez = Zone(**zone_object)
        if selected_car.fuel_type == "DIESEL":
            if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel):
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ. No additinoal fee is required for vehicles over Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol.',
                }
                return (response)
            else:
                response = {
                    'notification_type': 'error',
                    'notification_msg': f'Selected vehicle is NOT permited in {city} LEZ. Additional daily registration tax is requied for vehicles below Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol.',
                }
                return (response)
        elif selected_car.fuel_type=="ELECTRIC":
            response = {
                'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ. No additinoal fee is required for electric vehicles.',
            }
            return (response)
        else:
            if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol):
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ. No additinoal fee is required for vehicles over Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol.',
                }
                return (response)
            else:
                response = {
                    'notification_type': 'error',
                    'notification_msg': f'Selected vehicle is NOT permited in {city} LEZ. Additional daily registration tax is requied for vehicles below Euro {lez.minimum_diesel} diesel and Euro {lez.minimum_petrol} petrol.',
                }
                return (response)
    
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)

def check_netherlands(city, selected_car, start_time=None, end_time=None):
    print("-> executing check_netherlands()")
    zone = Zone.query.filter_by(city=city).first()
    if zone:
        # If the city exists, create an object with its values
        zone_object = {
            'id': zone.id,
            'country': zone.country,
            'city': zone.city,
            'registration_class': zone.registration_class,
            'minimum_diesel': zone.minimum_diesel,
            'minimum_petrol': zone.minimum_petrol,
            'required_registration': zone.required_registration,
            'exception_country':zone.exception_country
        }
        lez = Zone(**zone_object)
        if selected_car.fuel_type == "DIESEL":
            if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel):
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ. No registration required',
                }
                return (response)
            else:
                response = {
                    'notification_type': 'error',
                    'notification_msg': f'Selected vehicle is NOT permited in {city} LEZ. Vehicles below Euro {lez.minimum_diesel} diesel are not allowed.',
                }
                return (response)
        elif selected_car.fuel_type=="ELECTRIC":
            response = {
                'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ. No registration required',
            }
            return (response)
        else:
            if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol):
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ. No registration required',
                }
                return (response)
            else:
                response = {
                    'notification_type': 'error',
                    'notification_msg': f'Selected vehicle is NOT permited in {city} LEZ. Vehicles below Euro {lez.minimum_diesel} diesel are not allowed.',
                }
                return (response)
    
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)



def check_bulgaria(city, selected_car, start_time=None, end_time=None):
    print("-> executing check_bulgaria()")
    zone = Zone.query.filter_by(city=city).first()
    if zone:
            # If the city exists, create an object with its values
            zone_object = {
                'id': zone.id,
                'country': zone.country,
                'city': zone.city,
                'registration_class': zone.registration_class,
                'minimum_diesel': zone.minimum_diesel,
                'minimum_petrol': zone.minimum_petrol,
                'required_registration': zone.required_registration,
                'exception_country':zone.exception_country
            }
            lez = Zone(**zone_object)
            if start_time and end_time:
                # Convert start_time and end_time strings to datetime objects
                trip_start_date = datetime.strptime(start_time, '%Y-%m-%d')
                trip_end_date = datetime.strptime(end_time, '%Y-%m-%d')

                # Get temporary LEZ start and end dates from Zone
                lez_start_date_str = Zone.get_temporary_start(city)
                lez_end_date_str = Zone.get_temporary_end(city)

                # Convert LEZ start and end dates to datetime objects
                if trip_start_date.month<=6:
                    lez_start_date = datetime.strptime(lez_start_date_str, '%m-%d').replace(year=trip_start_date.year-1)
                else:
                    lez_start_date = datetime.strptime(lez_start_date_str, '%m-%d').replace(year=trip_start_date.year)
                
                lez_end_date = datetime.strptime(lez_end_date_str, '%m-%d').replace(year=lez_start_date.year+1)
                print("trip start:", trip_start_date)
                print("lez start:", lez_start_date)
                print("trip end:", trip_end_date)
                print("lez end:", lez_end_date)

                if trip_start_date>=lez_start_date and trip_end_date<=lez_end_date: 
                    print("mai mic")
                else:
                    print("cplm")

                #print(f"LEZ is on from {lez_start_date} to {lez_end_date}. ")
                #print(f"Your trip is from {trip_start_date} to {trip_end_date}. ")

                if (trip_start_date>=lez_start_date and trip_end_date<=lez_end_date) or \
                    (trip_start_date<=lez_start_date and trip_end_date>=lez_start_date and trip_end_date<=lez_end_date) or\
                    (trip_start_date>=lez_start_date and trip_start_date <=lez_end_date and trip_end_date>=lez_end_date) or\
                    (trip_start_date<=lez_end_date and trip_end_date>=lez_end_date) :
                    print("The trip overlaps with the LEZ period")
                    if selected_car.registration_country =='Bulgaria':      
                        if lez.required_registration in selected_car.bulgaria_registrations:
                            response = {
                                    'notification_type': 'success',
                                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Vehicle has the required registration ({lez.required_registration}).',
                                }
                            return (response)  
                        else:
                            response = {
                                    'notification_type': 'error',
                                    'notification_msg': f'Selected vehicle is NOT allowed in {city} LEZ. Vehicles registered in Bulgaria require {lez.required_registration} registration.',
                                }
                            return (response)
                    else:
                        if selected_car.fuel_type == "DIESEL":
                            if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel):
                                response = {
                                    'notification_type': 'success',
                                    'notification_msg': f'Selected vehicle is allowed in {city} during Winter LEZ. Foreign vehicles do not require registration.',
                                }
                                return (response)
                            else:
                                response = {
                                    'notification_type': 'error',
                                    'notification_msg': f'Selected vehicle is NOT allowed in {city} during Winter LEZ. Foreign vehicles do not require registration.',
                                }
                                return (response)
                        elif selected_car.fuel_type=="ELECTRIC":
                            response = {
                                'notification_type': 'success',
                                    'notification_msg': f'Selected vehicle is allowed in {city} during Winter LEZ. Foreign vehicles do not require registration.',
                            }
                            return (response)
                        else:
                            if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol):
                                response = {
                                    'notification_type': 'success',
                                    'notification_msg': f'Selected vehicle is allowed in {city} during Winter LEZ. Foreign vehicles do not require registration.',
                                }
                                return (response)
                            else:
                                response = {
                                    'notification_type': 'error',
                                    'notification_msg': f'Selected vehicle is NOT allowed in {city} during Winter LEZ. Foreign vehicles do not require registration.',
                                }
                                return (response)    
                else:     
                    response = {
                    'notification_type': 'success-no-lez',
                    'notification_msg': f'There are no restrictions outside Winter LEZ period in {city}.',
                    }
                    return (response)     
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)


    
#only anti-smog
def check_hungary(city, selected_car, start_time=None, end_time=None):
    aqi_value = getAQI(city)
    print(f"AQI{city} ", aqi_value )
    print("-> executing check_hungary()")
    zone = Zone.query.filter_by(city=city).first()

    if aqi_value >=50:

        if zone:
            # If the city exists, create an object with its values
            zone_object = {
                    'id': zone.id,
                    'country': zone.country,
                    'city': zone.city,
                    'registration_class': zone.registration_class,
                    'minimum_diesel': zone.minimum_diesel,
                    'minimum_petrol': zone.minimum_petrol,
                }
            lez = Zone(**zone_object)
            if selected_car.fuel_type == "DIESEL":
                if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel):
                    response = {
                        'notification_type': 'success',
                        'notification_msg': f'Selected vehicle is allowed in {city} during emergency LEZ (Air Quality Index above 50).',
                    }
                    return (response)
                else:
                    response = {
                        'notification_type': 'error',
                        'notification_msg': f'Selected vehicle is NOT allowed in {city} during emergency LEZ (Air Quality Index above 50).',
                    }
                    return (response)
            elif selected_car.fuel_type=="ELECTRIC":
                response = {
                    'notification_type': 'success',
                        'notification_msg': f'Selected vehicle is allowed in {city} during emergency LEZ (Air Quality Index above 50).',
                }
                return (response)
            else:
                if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol):
                    response = {
                        'notification_type': 'success',
                        'notification_msg': f'Selected vehicle is allowed in {city} during emergency LEZ (Air Quality Index above 50).',
                    }
                    return (response)
                else:
                    response = {
                        'notification_type': 'error',
                        'notification_msg': f'Selected vehicle is NOT allowed in {city} during emergency LEZ (Air Quality Index above 50).',
                    }
                    return (response)
    
        else:
            response = {
                'notification_type': 'success-no-lez',
                'notification_msg': f'There is no LEZ in {city}.',
                }
            return (response)
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': "You are allowed to drive in {city}. Emergency LEZ is not active while Air Quality Index is below 50. ",
            }
        return (response)

def check_poland(city, selected_car, start_time=None, end_time=None,selected_car_reg_date=None):
    print("-> executing check_poland()")
    zone = Zone.query.filter_by(city=city).first()
    if zone:
        # If the city exists, create an object with its values
        zone_object = {
                'id': zone.id,
                'country': zone.country,
                'city': zone.city,
                'registration_class': zone.registration_class,
                'minimum_diesel': zone.minimum_diesel,
                'minimum_petrol': zone.minimum_petrol,
            }
        lez = Zone(**zone_object)
        print(lez.minimum_diesel)
        selected_car_reg_date = datetime.strptime(selected_car_reg_date, '%Y-%m-%d')
        if selected_car_reg_date >=datetime.strptime("2023-03-01", '%Y-%m-%d'):
            x=-1
        else:
            x=0
        if selected_car.fuel_type == "DIESEL":
            if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel[x]):
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ. No registration required',
                }
                return (response)
            else:
                response = {
                    'notification_type': 'error',
                    'notification_msg': f'Selected vehicle is NOT permited in {city} LEZ. Restrictions vary based on vehicle\'s registration date.',
                }
                return (response)
        elif selected_car.fuel_type=="ELECTRIC":
            response = {
                'notification_type': 'success',
                'notification_msg': f'Selected vehicle is allowed in {city} LEZ. No registration required',
            }
            return (response)
        else:
            if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol[x]):
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ. No registration required',
                }
                return (response)
            else:
                response = {
                    'notification_type': 'error',
                    'notification_msg': f'Selected vehicle is NOT permited in {city} LEZ. Restrictions vary based on vehicle\'s registration date.',
                }
                return (response)

    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)

def check_portugal(city, selected_car, start_time=None, end_time=None):
    print("-> executing check_portugal()")
    zone = Zone.query.filter_by(city=city).first()
    if zone:
        # If the city exists, create an object with its values
        zone_object = {
                'id': zone.id,
                'country': zone.country,
                'city': zone.city,
                'registration_class': zone.registration_class,
                'minimum_diesel': zone.minimum_diesel,
                'minimum_petrol': zone.minimum_petrol,
            }
        lez = Zone(**zone_object)
        if selected_car.fuel_type == "DIESEL":
            if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel):
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ.',
                }
                return (response)
            else:
                response = {
                    'notification_type': 'error',
                    'notification_msg': f'Selected vehicle is NOT permited in {city} LEZ. Vehicles below Euro {lez.minimum_diesel} diesel or Euro {lez.minimum_petrol} petrol are not allowed.',
                }
                return (response)
        elif selected_car.fuel_type=="ELECTRIC":
            response = {
                'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ.',
            }
            return (response)
        else:
            if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol):
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'Selected vehicle is allowed in {city} LEZ.',
                }
                return (response)
            else:
                response = {
                    'notification_type': 'error',
                    'notification_msg': f'Selected vehicle is NOT permited in {city} LEZ. Vehicles below Euro {lez.minimum_diesel} diesel or Euro {lez.minimum_petrol} petrol are not allowed.',
                }
                return (response)
    
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)


def check_spain(city, selected_car, start_time=None, end_time=None):
    print("-> executing check_spain()")
    zone = Zone.query.filter_by(city=city).first()
    if zone:
        # If the city exists, create an object with its values
        zone_object = {
                'id': zone.id,
                'country': zone.country,
                'city': zone.city,
                'registration_class': zone.registration_class,
                'minimum_diesel': zone.minimum_diesel,
                'minimum_petrol': zone.minimum_petrol,
                'required_registration': zone.required_registration
            }
        lez = Zone(**zone_object)
        if selected_car.registration_country == "Spain":
            if selected_car.spain_registrations =='Distintivo Ambiental Cero' or selected_car.spain_registrations and (selected_car.spain_registrations[-1])>=(lez.required_registration[-1]):
                response = {
                    'notification_type': 'success',
                    'notification_msg': f'You are allowed to drive in {lez.city} LEZ. Your car has {selected_car.spain_registrations} and {lez.required_registration} is required for Spanish vehicles.',
                }
                return (response)
            else:
                response = {
                    'notification_type': 'error',
                    'notification_msg': f'You are NOT allowed to drive in {lez.city} LEZ. Your car has {selected_car.spain_registrations} and {lez.required_registration} is required for Spanish vehicles.',
                }
                return (response)
        #vehicle is not registered in spain
        else:
            if city == "Barcelona":
                if 'Barcelona' in str(selected_car.spain_registrations):
                    response = {
                        'notification_type': 'success',
                        'notification_msg': f'You are allowed to drive in {lez.city} LEZ. Vehicle has the the special registration for Barcelona LEZ.',
                    }
                    return (response)
                else:
                    response = {
                        'notification_type': 'error',
                        'notification_msg': f'You are NOT allowed to drive in {lez.city} LEZ. Foreign vehicles require special registration for {city} LEZ.',
                    }
                    return (response)
            else:
                if selected_car.fuel_type == "DIESEL":
                    if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel):
                        response = {
                            'notification_type': 'success',
                            'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Foreign vehicles do not require sticker registration but should be eligible for {lez.required_registration}.',
                        }
                        return (response)
                    else:
                        response = {
                            'notification_type': 'error',
                            'notification_msg': f'Selected vehicle is NOT allowed in {city} LEZ. Foreign vehicles do not require sticker registration but should be eligible for {lez.required_registration}.',
                        }
                        return (response)
                elif selected_car.fuel_type=="ELECTRIC":
                    response = {
                        'notification_type': 'success',
                            'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Foreign vehicles do not require sticker registration but should be eligible for {lez.required_registration}.',
                    }
                    return (response)
                else:
                    if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol):
                        response = {
                            'notification_type': 'success',
                            'notification_msg': f'Selected vehicle is allowed in {city} LEZ. Foreign vehicles do not require sticker registration but should be eligible for {lez.required_registration}.',
                        }
                        return (response)
                    else:
                        response = {
                            'notification_type': 'error',
                            'notification_msg': f'Selected vehicle is NOT allowed in {city} LEZ. Foreign vehicles do not require sticker registration but should be eligible for {lez.required_registration}.',
                        }
                        return (response)
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)


def check_italy(city, selected_car, start_time=None, end_time=None):
    print("-> executing check_italy()")
    zone = Zone.query.filter(
        or_(
            Zone.city.ilike(f'%{city}%'),
            Zone.city_alias.ilike(f'%{city}%')
        )
    ).first()
    if zone:
            # If the city exists, create an object with its values
            zone_object = {
                'id': zone.id,
                'country': zone.country,
                'city': zone.city,
                'registration_class': zone.registration_class,
                'minimum_diesel': zone.minimum_diesel,
                'minimum_petrol': zone.minimum_petrol,
                'required_registration': zone.required_registration,
                'exception_country':zone.exception_country
            }
            lez = Zone(**zone_object)
            if start_time and end_time:
                # Convert start_time and end_time strings to datetime objects
                trip_start_date = datetime.strptime(start_time, '%Y-%m-%d')
                print("trip start:", trip_start_date)
                trip_end_date = datetime.strptime(end_time, '%Y-%m-%d')
                print("trip end:", trip_end_date)

                # Get temporary LEZ start and end dates from Zone
                lez_start_date_str = Zone.get_temporary_start(lez.city)
                lez_end_date_str = Zone.get_temporary_end(lez.city)

                # Convert LEZ start and end dates to datetime objects
                if trip_start_date.month<=6:
                    lez_start_date = datetime.strptime(lez_start_date_str, '%m-%d').replace(year=trip_start_date.year-1)
                else:
                    lez_start_date = datetime.strptime(lez_start_date_str, '%m-%d').replace(year=trip_start_date.year)
                
                lez_end_date = datetime.strptime(lez_end_date_str, '%m-%d').replace(year=lez_start_date.year+1)
                print("lez start:", lez_start_date)
                print("lez end:", lez_end_date)

                if (trip_start_date>=lez_start_date and trip_end_date<=lez_end_date) or \
                    (trip_start_date<=lez_start_date and trip_end_date>=lez_start_date and trip_end_date<=lez_end_date) or\
                    (trip_start_date>=lez_start_date and trip_start_date <=lez_end_date and trip_end_date>=lez_end_date) or\
                    (trip_start_date<=lez_end_date and trip_end_date>=lez_end_date) :
                    print("The trip overlaps with the LEZ period")

                    lez.minimum_diesel=Zone.get_temporary_diesel(lez.city)
                    lez.minimum_petrol=Zone.get_temporary_petrol(lez.city)
                    print('zdis',lez.minimum_diesel)

                    if selected_car.fuel_type == "DIESEL":
                        if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel):
                            response = {
                                'notification_type': 'success',
                                'notification_msg': f'Selected vehicle is allowed in {city} during Winter LEZ.',
                            }
                            return (response)
                        else:
                            response = {
                                'notification_type': 'error',
                                'notification_msg': f'Selected vehicle is NOT permited in {city} during Winter LEZ. Vehicles below Euro {lez.minimum_diesel} diesel or Euro {lez.minimum_petrol} petrol are not allowed.',
                            }
                            return (response)
                    elif selected_car.fuel_type=="ELECTRIC":
                        response = {
                            'notification_type': 'success',
                                'notification_msg': f'Selected vehicle is allowed in {city} during Winter LEZ.',
                        }
                        return (response)
                    else:
                        if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol):
                            response = {
                                'notification_type': 'success',
                                'notification_msg': f'Selected vehicle is allowed in {city} during Winter LEZ.',
                            }
                            return (response)
                        else:
                            response = {
                                'notification_type': 'error',
                                'notification_msg': f'Selected vehicle is NOT permited in {city} during Winter LEZ. Vehicles below Euro {lez.minimum_diesel} diesel or Euro {lez.minimum_petrol} petrol are not allowed.',
                            }
                            return (response)
    

                else:
                    print(f"Temporary LEZ not active in this period. ")
                    if selected_car.fuel_type == "DIESEL":
                        if int(selected_car.euro_standard[-1])>=int(lez.minimum_diesel):
                            response = {
                                'notification_type': 'success',
                                'notification_msg': f'Selected vehicle is allowed in {city} LEZ.',
                            }
                            return (response)
                        else:
                            response = {
                                'notification_type': 'error',
                                'notification_msg': f'Selected vehicle is NOT permited in {city} LEZ. Vehicles below Euro {lez.minimum_diesel} diesel or Euro {lez.minimum_petrol} petrol are not allowed.',
                            }
                            return (response)
                    elif selected_car.fuel_type=="ELECTRIC":
                        response = {
                            'notification_type': 'success',
                                'notification_msg': f'Selected vehicle is allowed in {city} LEZ.',
                        }
                        return (response)
                    else:
                        if int(selected_car.euro_standard[-1])>=int(lez.minimum_petrol):
                            response = {
                                'notification_type': 'success',
                                'notification_msg': f'Selected vehicle is allowed in {city} LEZ.',
                            }
                            return (response)
                        else:
                            response = {
                                'notification_type': 'error',
                                'notification_msg': f'Selected vehicle is NOT permited in {city} LEZ. Vehicles below Euro {lez.minimum_diesel} diesel or Euro {lez.minimum_petrol} petrol are not allowed.',
                            }
                            return (response)
                
    else:
        response = {
            'notification_type': 'success-no-lez',
            'notification_msg': f'There is no LEZ in {city}.',
            }
        return (response)




