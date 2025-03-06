import sqlite3
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from website.models import Car, User, SavedRoute, Zone, ZoneTemporaryData, GeneralRegistrations, \
    BelgiumRegistrations, BulgariaRegistrations, DenmarkRegistrations, FranceRegistrations, GermanyRegistrations, \
    GreeceRegistrations, ItalyAccess, NetherlandsRegistrations, PolandRegistrations, PortugalRefistrations, \
    SpainRegistrations, UnitedKingdomRegistrations, RequestLog, BlockedUser, Base

# SQLite connection
sqlite_connection = sqlite3.connect(r'D:\Licenta\instance\users_databse.db')

cursor = sqlite_connection.cursor()
cursor.execute("SELECT * FROM car")
rows = cursor.fetchall()

for row in rows:
    print(row)

sqlite_connection.close()


