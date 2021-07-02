from astropy import units as u
from astropy.time import Time
from poliastro.bodies import Earth
from poliastro.twobody import Orbit

r = [8449.401305, 9125.794363, -17.461357] * u.km
v = [-1.419072, 6.780149, 0.002865] * u.km / u.s
t = Time("2021-06-26T19:20:00.000")

orb = Orbit.from_vectors(Earth, r, v, epoch=t)
print(f"Semimajor axis: {orb.a}")
print(f"Eccentricity: {orb.ecc}")
print(f"Inclination: {orb.inc.to(u.deg)}")
print(f"Longitude of the ascending node: {orb.raan.to(u.deg)}")
print(f"Argument of perigee: {orb.argp.to(u.deg)}")
print(f"True anomaly: {orb.nu.to(u.deg)}")

