from . import db
from flask_login import UserMixin
from sqlalchemy import text
from datetime import datetime
from sqlalchemy import asc
from datetime import datetime, timezone



class Car(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    owner_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    brand = db.Column(db.String(50))
    model = db.Column(db.String(50))
    year = db.Column(db.Integer)
    fuel_type = db.Column(db.String(50))
    euro_standard = db.Column(db.String(50))
    dpf=db.Column(db.Boolean)
    registration_country=db.Column(db.String(50))

    # registrations
    belgium_registrations= db.Column(db.String(50))
    bulgaria_registrations= db.Column(db.String(50))
    denmark_registrations= db.Column(db.String(50))
    france_registrations = db.Column(db.String(50))
    germany_registrations = db.Column(db.String(50))
    greece_registrations= db.Column(db.String(50))
    netherlands_registrations= db.Column(db.String(50))
    norway_registrations= db.Column(db.String(50))
    poland_registrations= db.Column(db.String(50))
    spain_registrations = db.Column(db.String(50))
    united_kingdom_registrations= db.Column(db.String(50))

    def __init__(self, owner_id=None, brand=None, model=None, year=None, fuel_type=None, euro_standard=None,dpf=True ,registration_country=None, belgium_registrations=None, bulgaria_registrations=None, denmark_registrations=None, france_registrations=None, germany_registrations=None, greece_registrations=None, netherlands_registrations=None, norway_registrations=None, poland_registrations=None, spain_registrations=None, united_kingdom_registrations=None):
        self.owner_id = owner_id
        self.brand = brand
        self.model = model
        self.year = year
        self.fuel_type = fuel_type
        self.euro_standard = euro_standard
        self.registration_country = registration_country
        self.dpf=dpf
        self.belgium_registrations = belgium_registrations
        self.bulgaria_registrations = bulgaria_registrations
        self.denmark_registrations = denmark_registrations
        self.france_registrations = france_registrations
        self.germany_registrations = germany_registrations
        self.greece_registrations = greece_registrations
        self.netherlands_registrations = netherlands_registrations
        self.norway_registrations = norway_registrations
        self.poland_registrations = poland_registrations
        self.spain_registrations = spain_registrations
        self.united_kingdom_registrations = united_kingdom_registrations

class SavedRoute(db.Model):
    __tablename__ = 'saved_routes'

    id = db.Column(db.Integer, primary_key=True)
    owner_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    destinations_json = db.Column(db.Text)
    destinations_text = db.Column(db.Text)

    def __init__(self, user_id, destinations,destinations_text):
        self.owner_id = user_id
        self.destinations_json = destinations
        self.destinations_text  = destinations_text

    def __repr__(self):
        return f"<SavedRoute(id={self.id}, user_id={self.user_id}, destinations={self.destinations})>"
    

class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(150), unique=True)
    password=db.Column(db.String(150))
    first_name=db.Column(db.String(150))
    cars = db.relationship('Car')
    saved_routes = db.relationship('SavedRoute', backref='user', lazy=True) # corrected relationship name
    is_admin = db.Column(db.Boolean, default=False)


class Zone(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    country = db.Column(db.String(50))
    city = db.Column(db.String(50))
    registration_class=db.Column(db.String(50))
    minimum_diesel=db.Column(db.Integer)
    minimum_petrol=db.Column(db.Integer)
    fines=db.Column(db.String(50))
    registration_type = db.Column(db.Text)
    registration_validity = db.Column(db.Text)
    required_registration=db.Column(db.String(50))
    exception_country=db.Column(db.String(50))
    official_page=db.Column(db.String(150))
    description = db.Column(db.Text)
    city_alias = db.Column(db.Text)


    @staticmethod
    def get_countries():
        countries = Zone.query.with_entities(Zone.country).distinct().order_by(asc(Zone.country)).all()
        countries_with_lez = [country[0].strip("()''") for country in countries]
        
        return countries_with_lez

    @staticmethod
    def get_countries_and_cities():
        countries = Zone.query.with_entities(Zone.country).distinct().order_by(asc(Zone.country)).all()
        countries_with_lez = [country[0].strip("()''") for country in countries]

        cities_by_country = {}
        for country in countries_with_lez:
            cities_query = Zone.query.filter_by(country=country).with_entities(Zone.city).order_by(asc(Zone.city)).all()
            cities = [city[0] for city in cities_query]
            cities_by_country[country] = cities
        
        return cities_by_country

    @classmethod
    def get_description_by_city(cls, city):
        query = text("SELECT description FROM Zone WHERE city = :city")
        result = db.session.execute(query, {"city": city})
        row = result.fetchone()
        if row:
            return row.description
        return None
    

    @classmethod
    def get_fines(cls, city_name):
        zone = Zone.query.filter(Zone.city.ilike(f'%{city_name}%')).first()
        return zone.fines if zone else None

    @classmethod
    def get_required_registration(cls, city_name):
        zone = Zone.query.filter(Zone.city.ilike(f'%{city_name}%')).first()
        return zone.required_registration if zone else None
    
    @classmethod
    def get_registration_type(cls, city_name):
        zone = Zone.query.filter(Zone.city.ilike(f'%{city_name}%')).first()
        return zone.registration_type if zone else None

    @classmethod
    def get_minimum_diesel_petrol(cls, city_name):
        zone = Zone.query.filter(Zone.city.ilike(f'%{city_name}%')).first()
        min_diesel = zone.minimum_diesel if zone else None
        min_petr = zone.minimum_petrol if zone else None
        return f"Only vehicles Euro {min_diesel} Diesel and Euro {min_petr} Petrol are allowed. "


    @classmethod
    def get_minimum_petrol(cls, city_name):
        zone = Zone.query.filter(Zone.city.ilike(f'%{city_name}%')).first()
        return zone.minimum_petrol if zone else None
    

    @classmethod
    def get_official_page(cls, city_name):
        zone = Zone.query.filter(Zone.city.ilike(f'%{city_name}%')).first()
        return zone.official_page if zone else None


    @classmethod
    def get_temporary_data(cls, city_name):
        # Query ZoneTemporaryData to get the required_registration for the given city
        temporary_data_entry = ZoneTemporaryData.query.filter_by(city=city_name).first()
        
        if temporary_data_entry:
            return temporary_data_entry.temporary_data
        else:
            return None
        
    @classmethod
    def get_temporary_start(cls, city_name):
        # Query ZoneTemporaryData to get the required_registration for the given city
        temporary_data_entry = ZoneTemporaryData.query.filter_by(city=city_name).first()
        
        if temporary_data_entry:
            return temporary_data_entry.tp_lez_start
        else:
            return None
    
    @classmethod
    def get_temporary_end(cls, city_name):
        # Query ZoneTemporaryData to get the required_registration for the given city
        temporary_data_entry = ZoneTemporaryData.query.filter_by(city=city_name).first()
        
        if temporary_data_entry:
            return temporary_data_entry.tp_lez_end
        else:
            return None
    
    @classmethod
    def get_temporary_diesel(cls, city_name):
        # Query ZoneTemporaryData to get the required_registration for the given city
        temporary_data_entry = ZoneTemporaryData.query.filter_by(city=city_name).first()
        
        if temporary_data_entry:
            return temporary_data_entry.tp_minimum_diesel
        else:
            return None
    
    @classmethod
    def get_temporary_petrol(cls, city_name):
        # Query ZoneTemporaryData to get the required_registration for the given city
        temporary_data_entry = ZoneTemporaryData.query.filter_by(city=city_name).first()
        
        if temporary_data_entry:
            return temporary_data_entry.tp_minimum_petrol
        else:
            return None
        
    @classmethod
    def get_minimum_temporary_diesel_petrol(cls, city_name):
        zone = ZoneTemporaryData.query.filter_by(city=city_name).first()
        min_diesel = zone.tp_minimum_diesel if zone else None
        min_petr = zone.tp_minimum_petrol if zone else None
        return f"Only vehicles Euro {min_diesel} Diesel and Euro {min_petr} Petrol are allowed. "

    

class ZoneTemporaryData(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    zone_id = db.Column(db.Integer, db.ForeignKey('zone.id'))
    city = db.Column(db.String(50))
    country = db.Column(db.String(50))
    temporary_data = db.Column(db.Text)
    tp_lez_start=db.Column(db.Text)
    tp_lez_end=db.Column(db.Text)
    tp_minimum_diesel=db.Column(db.Integer)
    tp_minimum_petrol=db.Column(db.Integer)

    # Define the relationship to the Zone table
    zone = db.relationship('Zone', backref=db.backref('temporary_data', lazy=True))

    

class GeneralRegistrations(db.Model):
    __abstract__ = True

    id = db.Column(db.Integer, primary_key=True)
    country = db.Column(db.String(50))
    registration_type = db.Column(db.String(50))
    name = db.Column(db.String(50))
    minimum_diesel = db.Column(db.String(50))
    minimum_petrol = db.Column(db.String(50))
    result = db.Column(db.Text) #resume
    description = db.Column(db.Text)
    image_url = db.Column(db.String(255))

    @classmethod
    def find_best_registration_badge(cls, car_fuel_type, car_euro_standard):
        # Filter badges based on fuel type (diesel)
        badges = cls.query.all()
        best_badge = None

        for badge in badges:
            if car_fuel_type == "DIESEL":
                minimum_standard = badge.minimum_diesel
            else:
                minimum_standard = badge.minimum_petrol

            if minimum_standard != '-' and int(car_euro_standard[-1]) >= int(minimum_standard):
                best_badge = badge
                return best_badge
            
        return best_badge




# Define classes for each country
class BelgiumRegistrations(GeneralRegistrations):
    __tablename__ = 'Belgium_registrations'
    exception_country = db.Column(db.String(50))


class BulgariaRegistrations(GeneralRegistrations):
    __tablename__ = 'Bulgaria_registrations'

class DenmarkRegistrations(GeneralRegistrations):
    __tablename__ = 'Denmark_registrations'
    exception_country = db.Column(db.String(50))

class FranceRegistrations(GeneralRegistrations):

    __tablename__ = 'France_registrations'

    def find_best_registration_badge(cls, car_fuel_type, car_euro_standard):
        # Filter badges based on fuel type (diesel)
        badges = cls.query.all()
        best_badge = None
        if car_fuel_type == 'ELECTRIC' or car_fuel_type == 'HYDROGEN':
            badge = cls.query.filter_by(name='Crit Air 0/E').first()
            return badge
        else:
            for badge in badges:
                if car_fuel_type == "DIESEL":
                    minimum_standard = badge.minimum_diesel
                else:
                    minimum_standard = badge.minimum_petrol

                if minimum_standard != '-' and int(car_euro_standard[-1]) >= int(minimum_standard):
                    best_badge = badge
                    return best_badge
            
            return best_badge

class GermanyRegistrations(GeneralRegistrations):
    __tablename__ = 'Germany_registrations'
    minimum_diesel_wdpf = db.Column(db.String(50))
    minimum_petrol_wdpf = db.Column(db.String(50))

    def find_best_registration_badge(cls, car_fuel_type, car_euro_standard,car_dpf):
        # Filter badges based on fuel type (diesel)
        print("dpf", car_dpf)
        badges = cls.query.all()
        best_badge = None
        if car_fuel_type == 'ELECTRIC' or car_fuel_type == 'HYDROGEN':
            badge = cls.query.filter_by(name='Umweltplakette Green - 4').first()
            return badge
        else:
            for badge in badges:
                if car_fuel_type == "DIESEL":
                    if car_dpf != "false":
                        minimum_standard = badge.minimum_diesel_wdpf
                    else:
                        minimum_standard=badge.minimum_diesel
                else:
                    if car_dpf != "false":
                        minimum_standard = badge.minimum_petrol_wdpf
                    else:
                        minimum_standard=badge.minimum_petrol      
                print("min: ",minimum_standard)
                if minimum_standard != '-' and int(car_euro_standard[-1]) >= int(minimum_standard):
                    best_badge = badge
                    return best_badge
            
            return best_badge

class GreeceRegistrations(GeneralRegistrations):
    __tablename__ = 'Greece_registrations'

class ItalyAccess(GeneralRegistrations):
    __tablename__ = 'Italy_access'

class NetherlandsRegistrations(GeneralRegistrations):
    __tablename__ = 'Netherlands_registrations'
    exception_country = db.Column(db.String(50))

class PolandRegistrations(GeneralRegistrations):
    __tablename__ = 'Poland_registrations'
    min_dis_bf_010323 = db.Column(db.String(50))
    min_dis_af_010323 = db.Column(db.String(50))
    min_pet_bf_010323 = db.Column(db.String(50))
    min_pet_af_010323 = db.Column(db.String(50))


    def find_best_registration_badge(cls, car_fuel_type, car_euro_standard,car_registration_date):
        # Filter badges based on fuel type (diesel)
        if car_registration_date=='':
            return 0
        badges = cls.query.all()
        best_badge = None
        if car_fuel_type == 'ELECTRIC' or car_fuel_type == 'HYDROGEN':
            badge = cls.query.filter_by(name='Warsaw + Krakow').first()
            return badge
        else:
            car_registration_date = datetime.strptime(car_registration_date, '%Y-%m-%d')
            for badge in badges:
                if car_registration_date >=datetime.strptime("2023-03-01", '%Y-%m-%d'):
                    if car_fuel_type == "DIESEL":
                        minimum_standard = badge.min_dis_af_010323
                        print("noua diesel")
                    else:
                        minimum_standard = badge.min_pet_af_010323
                        print("noua benzina")

                else:
                    if car_fuel_type == "DIESEL":
                        minimum_standard = badge.min_dis_bf_010323
                        print("veche diesel")

                    else:
                        minimum_standard = badge.min_pet_bf_010323
                        print("veche benzina")

                if minimum_standard != '-' and int(car_euro_standard[-1]) >= int(minimum_standard):
                    best_badge = badge
                    return best_badge
            
            return best_badge

class PortugalRefistrations(GeneralRegistrations):
    __tablename__ = 'Portugal_registrations'

class SpainRegistrations(GeneralRegistrations):
    __tablename__ = 'Spain_registrations'

    def find_best_registration_badge(cls, car_fuel_type, car_euro_standard):
        # Filter badges based on fuel type (diesel)
        badges = cls.query.all()
        best_badge = None
        if car_fuel_type == 'ELECTRIC' or car_fuel_type == 'HYDROGEN':
            badge = cls.query.filter_by(name='Distintivo Ambiental Cero').first()
            return badge
        elif car_fuel_type=="PHEV":
            badge = cls.query.filter_by(name='Distintivo Ambiental ECO').first()
            return badge
        else:
            for badge in badges[2:]:
                if car_fuel_type == "DIESEL":
                    minimum_standard = badge.minimum_diesel
                    if minimum_standard != '-' and int(car_euro_standard[-1]) >= int(minimum_standard):
                        return badge
                    print(minimum_standard)
                else:
                    minimum_standard = badge.minimum_petrol
                    print(minimum_standard)
                    if minimum_standard != '-' and int(car_euro_standard[-1]) >= int(minimum_standard):
                        return badge  

        return best_badge

class UnitedKingdomRegistrations(GeneralRegistrations):
    __tablename__ = 'UnitedKingdom_registrations'

# Function to dynamically select the appropriate subclass based on the country
def get_registration_class(country):
    if country == 'Germany':
        return GermanyRegistrations
    elif country == 'France':
        return FranceRegistrations
    elif country == 'Belgium':
        return BelgiumRegistrations
    elif country == 'Bulgaria':
        return BulgariaRegistrations
    elif country == 'Denmark':
        return DenmarkRegistrations
    elif country == 'Greece':
        return GreeceRegistrations
    elif country == 'Italy':
        return ItalyAccess
    elif country == 'Netherlands':
        return NetherlandsRegistrations
    elif country == 'Poland':
        return PolandRegistrations
    elif country == 'Portugal':
        return PortugalRefistrations
    elif country == 'Spain':
        return SpainRegistrations
    elif country == 'United Kingdom':
        return UnitedKingdomRegistrations
    # Add more countries as needed
    else:
        return None



class RequestLog(db.Model):
    __tablename__ = 'Requests_Log'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)  # Foreign key to User model
    ip_address = db.Column(db.String(50), nullable=False)  # Add this column
    endpoint = db.Column(db.String(255), nullable=False)
    timestamp = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

class BlockedUser(db.Model):
    __tablename__ = 'Blocked_Users'
    ip_address = db.Column(db.String(50), nullable=True, primary_key=True)  # For unauthenticated users
    user_id = db.Column(db.Integer, db.ForeignKey('user.id')) # For authenticated users
    blocked_until = db.Column(db.DateTime(timezone=True), nullable=False)
    total_bans = db.Column(db.Integer,default=0)