CREATE SCHEMA Hotel;


CREATE TABLE Hotel.Goscie (
    GoscID INT PRIMARY KEY,
    Imie VARCHAR(50),
    Nazwisko VARCHAR(50),
    Email VARCHAR(100),
    Telefon VARCHAR(20)
);

CREATE TABLE Hotel.TypyPokoi (
    TypPokojuID INT PRIMARY KEY,
    NazwaTypu VARCHAR(100),
    Pojemnosc INT,
    Opis TEXT
);

CREATE TABLE Hotel.Pokoje (
    PokojID INT PRIMARY KEY,
    Pojemnosc INT,
    MaBalkon BOOLEAN,
    TypPokojuID INT,
    FOREIGN KEY (TypPokojuID) REFERENCES Hotel.TypyPokoi(TypPokojuID)
);

CREATE TABLE Hotel.PrzypisaniePokoju (
    PrzypisanieID INT PRIMARY KEY,
    GoscID INT,
    PokojID INT,
    FOREIGN KEY (GoscID) REFERENCES Hotel.Goscie(GoscID),
    FOREIGN KEY (PokojID) REFERENCES Hotel.Pokoje(PokojID)
);

CREATE TABLE Hotel.Rezerwacje (
    RezerwacjaID INT PRIMARY KEY,
    PrzypisanieID INT,
    DataPoczatkowa DATE,
    DataKoncowa DATE,
    FOREIGN KEY (PrzypisanieID) REFERENCES Hotel.PrzypisaniePokoju(PrzypisanieID)
);

CREATE TABLE Hotel.Platnosci (
    PlatnoscID INT PRIMARY KEY,
    RezerwacjaID INT,
    Kwota DECIMAL(10, 2),
    DataPlatnosci DATE,
    TypPlatnosci VARCHAR(50),
    FOREIGN KEY (RezerwacjaID) REFERENCES Hotel.Rezerwacje(RezerwacjaID)
);

CREATE TABLE Hotel.Uslugi (
    UslugaID INT PRIMARY KEY,
    NazwaUslugi VARCHAR(100),
    Cena DECIMAL(10, 2)
);

CREATE TABLE Hotel.UslugiRezerwacji (
    RezerwacjaID INT,
    UslugaID INT,
    Ilosc INT,
    PRIMARY KEY (RezerwacjaID, UslugaID),
    FOREIGN KEY (RezerwacjaID) REFERENCES Hotel.Rezerwacje(RezerwacjaID),
    FOREIGN KEY (UslugaID) REFERENCES Hotel.Uslugi(UslugaID)
);


ALTER TABLE Hotel.Goscie
ADD CONSTRAINT UC_Email UNIQUE (Email);


--CREATE OR REPLACE FUNCTION SprawdzWiekPrzedWstawieniem()
--RETURNS TRIGGER
--LANGUAGE plpgsql AS
--$$
--BEGIN
--    IF NEW.Wiek <= 0 THEN
--        RAISE EXCEPTION 'Wiek musi być liczbą dodatnią.';
--    END IF;
--    RETURN NEW;
--END;
--$$;

--CREATE TRIGGER SprawdzWiekPrzedWstawieniem
--BEFORE INSERT ON Hotel.Goscie
--FOR EACH ROW
--EXECUTE FUNCTION SprawdzWiekPrzedWstawieniem();
--
--DROP TRIGGER IF EXISTS SprawdzWiekPrzedWstawieniem ON Hotel.Goscie;


CREATE OR REPLACE FUNCTION verify_guest_data()
RETURNS TRIGGER AS $$
BEGIN
    -- Sprawdzenie, czy e-mail nie jest pusty
    IF NEW.Email IS NULL OR NEW.Email = '' THEN
        RAISE EXCEPTION 'Pole Email nie może być puste.';
    END IF;

    -- Sprawdzenie, czy adres email zawiera znak @
    IF POSITION('@' IN NEW.Email) = 0 THEN
        RAISE EXCEPTION 'Adres email musi zawierać znak "@".';
    END IF;

    -- Sprawdzenie, czy telefon nie jest pusty
    IF NEW.Telefon IS NULL OR NEW.Telefon = '' THEN
        RAISE EXCEPTION 'Pole Telefon nie może być puste.';
    END IF;

    -- Sprawdzenie, czy numer telefonu składa się z 9 cyfr
    IF NOT NEW.Telefon ~ '^[0-9]{9}$' THEN
        RAISE EXCEPTION 'Numer telefonu musi składać się z 9 cyfr.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_guest
BEFORE INSERT OR UPDATE ON Hotel.Goscie
FOR EACH ROW EXECUTE FUNCTION verify_guest_data();

CREATE OR REPLACE FUNCTION przed_wstawieniem_aktualizacja_typypokoi()
RETURNS TRIGGER AS $$
BEGIN
    -- Sprawdza, czy 'Pojemnosc' jest większa od 0
    IF NEW.Pojemnosc <= 0 THEN
        RAISE EXCEPTION 'Pojemność musi być większa od 0.';
    END IF;

    -- Sprawdza, czy 'NazwaTypu' nie jest pusta
    IF NEW.NazwaTypu IS NULL OR NEW.NazwaTypu = '' THEN
        RAISE EXCEPTION 'Nazwa typu nie może być pusta.';
    END IF;

    -- Jeśli wszystko jest w porządku, kontynuuje operację
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sprawdz_przed_wstawieniem_aktualizacja_typypokoi
BEFORE INSERT OR UPDATE ON Hotel.TypyPokoi
FOR EACH ROW EXECUTE FUNCTION przed_wstawieniem_aktualizacja_typypokoi();

CREATE OR REPLACE FUNCTION przed_wstawieniem_aktualizacja_pokoje()
RETURNS TRIGGER AS $$
BEGIN
    -- Sprawdza, czy 'Pojemnosc' jest większa od 0
    IF NEW.Pojemnosc <= 0 THEN
        RAISE EXCEPTION 'Pojemność musi być większa od 0.';
    END IF;

    -- Sprawdza, czy 'TypPokojuID' istnieje w tabeli 'Hotel.TypyPokoi'
    IF NOT EXISTS (SELECT 1 FROM Hotel.TypyPokoi WHERE TypPokojuID = NEW.TypPokojuID) THEN
        RAISE EXCEPTION 'TypPokojuID % nie istnieje w tabeli Hotel.TypyPokoi.', NEW.TypPokojuID;
    END IF;

    -- Jeśli wszystko jest w porządku, kontynuuje operację
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sprawdz_przed_wstawieniem_aktualizacja_pokoje
BEFORE INSERT OR UPDATE ON Hotel.Pokoje
FOR EACH ROW EXECUTE FUNCTION przed_wstawieniem_aktualizacja_pokoje();

CREATE OR REPLACE FUNCTION przed_wstawieniem_aktualizacja_przypisanie_pokoju()
RETURNS TRIGGER AS $$
BEGIN
    -- Sprawdza, czy 'GoscID' istnieje w tabeli 'Hotel.Goscie'
    IF NOT EXISTS (SELECT 1 FROM Hotel.Goscie WHERE GoscID = NEW.GoscID) THEN
        RAISE EXCEPTION 'GoscID % nie istnieje w tabeli Hotel.Goscie.', NEW.GoscID;
    END IF;

    -- Sprawdza, czy 'PokojID' istnieje w tabeli 'Hotel.Pokoje'
    IF NOT EXISTS (SELECT 1 FROM Hotel.Pokoje WHERE PokojID = NEW.PokojID) THEN
        RAISE EXCEPTION 'PokojID % nie istnieje w tabeli Hotel.Pokoje.', NEW.PokojID;
    END IF;

    -- Jeśli wszystko jest w porządku, kontynuuje operację
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sprawdz_przed_wstawieniem_aktualizacja_przypisanie_pokoju
BEFORE INSERT OR UPDATE ON Hotel.PrzypisaniePokoju
FOR EACH ROW EXECUTE FUNCTION przed_wstawieniem_aktualizacja_przypisanie_pokoju();

CREATE OR REPLACE FUNCTION przed_wstawieniem_aktualizacja_rezerwacje()
RETURNS TRIGGER AS $$
BEGIN
    -- Sprawdza, czy 'PrzypisanieID' istnieje w tabeli 'Hotel.PrzypisaniePokoju'
    IF NOT EXISTS (SELECT 1 FROM Hotel.PrzypisaniePokoju WHERE PrzypisanieID = NEW.PrzypisanieID) THEN
        RAISE EXCEPTION 'PrzypisanieID % nie istnieje w tabeli Hotel.PrzypisaniePokoju.', NEW.PrzypisanieID;
    END IF;

    -- Sprawdza, czy 'DataPoczatkowa' jest wcześniejsza niż 'DataKoncowa'
    IF NEW.DataPoczatkowa >= NEW.DataKoncowa THEN
        RAISE EXCEPTION 'Data początkowa musi być wcześniejsza niż data końcowa.';
    END IF;

    -- Jeśli wszystko jest w porządku, kontynuuje operację
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sprawdz_przed_wstawieniem_aktualizacja_rezerwacje
BEFORE INSERT OR UPDATE ON Hotel.Rezerwacje
FOR EACH ROW EXECUTE FUNCTION przed_wstawieniem_aktualizacja_rezerwacje();

CREATE OR REPLACE FUNCTION przed_wstawieniem_aktualizacja_platnosci()
RETURNS TRIGGER AS $$
BEGIN
    -- Sprawdza, czy 'RezerwacjaID' istnieje w tabeli 'Hotel.Rezerwacje'
    IF NOT EXISTS (SELECT 1 FROM Hotel.Rezerwacje WHERE RezerwacjaID = NEW.RezerwacjaID) THEN
        RAISE EXCEPTION 'RezerwacjaID % nie istnieje w tabeli Hotel.Rezerwacje.', NEW.RezerwacjaID;
    END IF;

    -- Sprawdza, czy kwota jest dodatnia
    IF NEW.Kwota <= 0 THEN
        RAISE EXCEPTION 'Kwota płatności musi być dodatnia.';
    END IF;

    -- Sprawdza, czy 'DataPlatnosci' nie jest w przyszłości
    IF NEW.DataPlatnosci > CURRENT_DATE THEN
        RAISE EXCEPTION 'Data płatności nie może być w przyszłości.';
    END IF;

    -- Jeśli wszystko jest w porządku, kontynuuje operację
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER sprawdz_przed_wstawieniem_aktualizacja_platnosci
BEFORE INSERT OR UPDATE ON Hotel.Platnosci
FOR EACH ROW EXECUTE FUNCTION przed_wstawieniem_aktualizacja_platnosci();

CREATE OR REPLACE FUNCTION przed_wstawieniem_aktualizacja_uslugi()
RETURNS TRIGGER AS $$
BEGIN
    -- Sprawdza, czy cena usługi jest dodatnia
    IF NEW.Cena <= 0 THEN
        RAISE EXCEPTION 'Cena usługi musi być dodatnia.';
    END IF;

    -- Jeśli wszystko jest w porządku, kontynuuje operację
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sprawdz_przed_wstawieniem_aktualizacja_uslugi
BEFORE INSERT OR UPDATE ON Hotel.Uslugi
FOR EACH ROW EXECUTE FUNCTION przed_wstawieniem_aktualizacja_uslugi();

CREATE OR REPLACE FUNCTION przed_wstawieniem_aktualizacja_uslugirezerwacji_rozszerzona()
RETURNS TRIGGER AS $$
DECLARE
    istniejeRezerwacja INT;
    istniejeUsluga INT;
BEGIN
    -- Sprawdza, czy ilość usługi jest większa niż 0
    IF NEW.Ilosc <= 0 THEN
        RAISE EXCEPTION 'Ilość usługi musi być większa niż 0.';
    END IF;

    -- Sprawdza, czy istnieje rekord w tabeli Rezerwacje
    SELECT COUNT(*) INTO istniejeRezerwacja FROM Hotel.Rezerwacje WHERE RezerwacjaID = NEW.RezerwacjaID;
    IF istniejeRezerwacja = 0 THEN
        RAISE EXCEPTION 'Rezerwacja o ID % nie istnieje.', NEW.RezerwacjaID;
    END IF;

    -- Sprawdza, czy istnieje rekord w tabeli Uslugi
    SELECT COUNT(*) INTO istniejeUsluga FROM Hotel.Uslugi WHERE UslugaID = NEW.UslugaID;
    IF istniejeUsluga = 0 THEN
        RAISE EXCEPTION 'Usługa o ID % nie istnieje.', NEW.UslugaID;
    END IF;

    -- Jeśli wszystko jest w porządku, kontynuuje operację
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER sprawdz_przed_wstawieniem_aktualizacja_uslugirezerwacji
BEFORE INSERT OR UPDATE ON Hotel.UslugiRezerwacji
FOR EACH ROW EXECUTE FUNCTION przed_wstawieniem_aktualizacja_uslugirezerwacji_rozszerzona();

SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'hjiqtilj'
  AND pid <> pg_backend_pid();


























