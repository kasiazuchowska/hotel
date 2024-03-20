INSERT INTO Hotel.Goscie (GoscID, Imie, Nazwisko, Email, Telefon)
VALUES
  (1, 'John', 'Doe', 'john.doe@example.com', '123-456-7890'),
  (2, 'Jane', 'Smith', 'jane.smith@example.com', '987-654-3210'),
  (3, 'Alice', 'Johnson', 'alice.j@example.com', '555-123-4567'),
  (4, 'Bob', 'Williams', 'bob.w@example.com', '789-012-3456');


INSERT INTO Hotel.TypyPokoi (TypPokojuID, NazwaTypu, Pojemnosc, Opis)
VALUES
  (1, 'Standardowy', 2, 'Standardowy pokój z podstawowymi udogodnieniami'),
  (2, 'Luksusowy', 4, 'Przestronny pokój z dodatkowymi udogodnieniami'),
  (3, 'Apartament', 3, 'Luksusowy apartament z widokiem'),
  (4, 'Ekonomiczny', 1, 'Mały pokój przyjazny dla budżetu');


INSERT INTO Hotel.Pokoje (PokojID, Pojemnosc, MaBalkon, TypPokojuID)
VALUES
  (101, 2, FALSE, 1),
  (102, 4, TRUE, 2),
  (103, 2, FALSE, 1),
  (104, 3, TRUE, 3);


INSERT INTO Hotel.PrzypisaniePokoju (PrzypisanieID, GoscID, PokojID)
VALUES
  (1, 1, 101),
  (2, 2, 102),
  (3, 3, 103),
  (4, 4, 104);


INSERT INTO Hotel.Uslugi (UslugaID, NazwaUslugi, Cena)
VALUES
  (1, 'Śniadanie', 15.00),
  (2, 'Parking', 10.00),
  (3, 'WiFi', 5.00),
  (4, 'Późne wymeldowanie', 20.00);
 

INSERT INTO Hotel.Rezerwacje (RezerwacjaID, PrzypisanieID, DataPoczatkowa, DataKoncowa)
VALUES
  (1, 1, '2024-01-20', '2024-01-25'),
  (2, 2, '2024-02-15', '2024-02-20'),
  (3, 3, '2024-03-10', '2024-03-15'),
  (4, 4, '2024-04-05', '2024-04-10');


INSERT INTO Hotel.UslugiRezerwacji (RezerwacjaID, UslugaID, Ilosc)
VALUES
  (1, 1, 2),
  (2, 2, 1),
  (3, 3, 1),
  (4, 4, 1);


INSERT INTO Hotel.Platnosci (PlatnoscID, RezerwacjaID, Kwota, DataPlatnosci, TypPlatnosci)
VALUES
  (1, 1, 250.00, '2024-01-25', 'Karta Kredytowa'),
  (2, 2, 120.00, '2024-02-20', 'Gotówka'),
  (3, 3, 180.00, '2024-03-15', 'Karta Kredytowa'),
  (4, 4, 90.00, '2024-04-10', 'Gotówka');
