
SELECT r.RezerwacjaID, SUM(p.Kwota) AS SumaPlatnosci
FROM Hotel.Rezerwacje r
JOIN Hotel.Platnosci p ON r.RezerwacjaID = p.RezerwacjaID
GROUP BY r.RezerwacjaID;


SELECT t.NazwaTypu, COUNT(r.RezerwacjaID) AS IloscRezerwacji
FROM Hotel.TypyPokoi t
JOIN Hotel.Pokoje p ON t.TypPokojuID = p.TypPokojuID
JOIN Hotel.PrzypisaniePokoju pr ON p.PokojID = pr.PokojID
JOIN Hotel.Rezerwacje r ON pr.PrzypisanieID = r.PrzypisanieID
GROUP BY t.NazwaTypu
HAVING COUNT(r.RezerwacjaID) > 1;


SELECT g.Imie, g.Nazwisko, COUNT(r.RezerwacjaID) AS IloscRezerwacji
FROM Hotel.Goscie g
JOIN Hotel.PrzypisaniePokoju pr ON g.GoscID = pr.GoscID
JOIN Hotel.Rezerwacje r ON pr.PrzypisanieID = r.PrzypisanieID
JOIN Hotel.Platnosci p ON r.RezerwacjaID = p.RezerwacjaID
GROUP BY g.Imie, g.Nazwisko
HAVING SUM(p.Kwota) > 200;


SELECT r.RezerwacjaID, p.PlatnoscID, p.Kwota, r.DataPoczatkowa, r.DataKoncowa
FROM Hotel.Rezerwacje r
JOIN Hotel.Platnosci p ON r.RezerwacjaID = p.RezerwacjaID
ORDER BY p.Kwota DESC
LIMIT 1;


SELECT RezerwacjaID, DataPoczatkowa, DataKoncowa
FROM Hotel.Rezerwacje
ORDER BY DataPoczatkowa DESC
LIMIT 3;


SELECT t.NazwaTypu, COUNT(r.RezerwacjaID) AS IloscRezerwacji
FROM Hotel.TypyPokoi t
JOIN Hotel.Pokoje p ON t.TypPokojuID = p.TypPokojuID
JOIN Hotel.PrzypisaniePokoju pr ON p.PokojID = pr.PokojID
JOIN Hotel.Rezerwacje r ON pr.PrzypisanieID = r.PrzypisanieID
GROUP BY t.NazwaTypu
ORDER BY IloscRezerwacji DESC;


SELECT SUM(Kwota) AS SumaPlatnosci
FROM Hotel.Platnosci;


SELECT AVG(Pojemnosc) AS SredniaPojemnosc
FROM Hotel.Pokoje
JOIN Hotel.PrzypisaniePokoju pr ON Hotel.Pokoje.PokojID = pr.PokojID
JOIN Hotel.Rezerwacje r ON pr.PrzypisanieID = r.PrzypisanieID;


SELECT MAX(IloscRezerwacji) AS MaxIloscRezerwacji
FROM (
    SELECT g.Imie, g.Nazwisko, COUNT(r.RezerwacjaID) AS IloscRezerwacji
    FROM Hotel.Goscie g
    JOIN Hotel.PrzypisaniePokoju pr ON g.GoscID = pr.GoscID
    JOIN Hotel.Rezerwacje r ON pr.PrzypisanieID = r.PrzypisanieID
    GROUP BY g.Imie, g.Nazwisko
) AS IloscRezerwacjiGoście;


CREATE VIEW WidokRezerwacji AS
SELECT r.RezerwacjaID, r.DataPoczatkowa, r.DataKoncowa, g.Imie AS ImieGoscia, g.Nazwisko AS NazwiskoGoscia
FROM Hotel.Rezerwacje r
JOIN Hotel.PrzypisaniePokoju pr ON r.PrzypisanieID = pr.PrzypisanieID
JOIN Hotel.Goscie g ON pr.GoscID = g.GoscID;


SELECT * FROM WidokRezerwacji;





