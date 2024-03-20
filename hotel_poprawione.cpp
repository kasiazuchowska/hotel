#include <iostream>
#include <pqxx/pqxx>
#include <cstdlib>

void executeSelect(pqxx::connection& connection, const std::string& selectSQL) {
    pqxx::nontransaction transaction(connection);
    pqxx::result result(transaction.exec(selectSQL));

    // Przetwarzanie wyników zapytania SELECT
    for (const auto& row : result) {
        for (const auto& field : row) {
            std::cout << field.name() << ": " << field.c_str() << "\t";
        }
        std::cout << "\n";
    }
    
}

int f(pqxx::connection& connection){
    std::cout << "1 - wprowadz dane\n2 - wypisz dane\n";
            std::string x;
            std::getline(std::cin, x);
            //std::cin >> x;
            system("clear");

            if(x == "1"){
                // Pytanie użytkownika o tabelę
                std::cout << "1 - Dodaj nowego goscia\n";
                std::cout << "2 - dodaj nowy typ pokoju\n";
                std::cout << "3 - dodaj nowy pokoj\n";
                std::cout << "4 - dodaj nowa usluge\n";
                std::cout << "5 - zloz nowa rezerwacje\n";
                std::cout << "6 - dodaj usluge do rezerwacji\n";
                std::cout << "7 - dodaj nowa platnosc\n";
                std::string tabela;
                //std::string dane;
                //std::cin >> tabela;
                std::getline(std::cin, tabela);
                if(tabela=="1"){
                    std::string goscID, imie, nazwisko, email, telefon;

                    std::cout << "Podaj ID goscia:\n";
                    std::getline(std::cin, goscID);

                    std::cout << "Podaj imie:\n";
                    std::getline(std::cin, imie);

                    std::cout << "Podaj nazwisko:\n";
                    std::getline(std::cin, nazwisko);

                    std::cout << "Podaj email:\n";
                    std::getline(std::cin, email);

                    std::cout << "Podaj telefon:\n";
                    std::getline(std::cin, telefon);

                    std::string insertDataSQL = "INSERT INTO Hotel.Goscie (GoscID, Imie, Nazwisko, Email, Telefon) VALUES (" + goscID + ", '" + imie + "', '" + nazwisko + "', '" + email + "', '" + telefon + "');";
                    pqxx::work transaction(connection);
                transaction.exec(insertDataSQL);
                transaction.commit();
                }
                else if(tabela=="2"){
                    std::string typPokojuID, nazwaTypu, pojemnosc, opis;
                    std::cout << "Podaj TypPokojuID\n";
                    std::getline(std::cin, typPokojuID);


                    std::cout << "Podaj nazwe typu\n";
                    std::getline(std::cin, nazwaTypu);
                    std::cout << "Podaj pojemnosc\n";
                    std::getline(std::cin, pojemnosc);
                    std::cout << "Podaj opis\n";
                    std::getline(std::cin, opis);

                    std::string insertDataSQL = "INSERT INTO Hotel.TypyPokoi (TypPokojuID, NazwaTypu, Pojemnosc, Opis) VALUES (" + typPokojuID + ",'" + nazwaTypu + "'," + pojemnosc + ",'" + opis + "');";
                    pqxx::work transaction(connection);
                transaction.exec(insertDataSQL);
                transaction.commit();
                }
                else if(tabela=="3"){
                    std::string s;
                    std::cout << "Dostepne typy pokoi:\n\n";
                    s = "SELECT * FROM Hotel.TypyPokoi;";
                    executeSelect(connection, s);

                    std::string pokojID, pojemnosc, maBalkon, typPokojuID;

                    std::cout << "Podaj ID pokoju\n";
                    std::getline(std::cin, pokojID);

                    std::cout << "Podaj pojemność\n";
                    std::getline(std::cin, pojemnosc);

                    std::cout << "Czy pokój ma balkon? (true dla tak, false dla nie)\n";
                    std::getline(std::cin, maBalkon);

                    std::cout << "Podaj ID typu pokoju\n";
                    std::getline(std::cin, typPokojuID);

                    std::string insertDataSQL = "INSERT INTO Hotel.Pokoje (PokojID, Pojemnosc, MaBalkon, TypPokojuID) VALUES (" + pokojID + ", " + pojemnosc + ", " + maBalkon + ", " + typPokojuID + ");";

                    pqxx::work transaction(connection);
                    transaction.exec(insertDataSQL);
                    transaction.commit();
    
                }
                else if(tabela=="4"){
                    std::string uslugaID, nazwaUslugi, cena;

                    std::cout << "Podaj ID uslugi:\n";
                    std::getline(std::cin, uslugaID);

                    std::cout << "Podaj nazwe uslugi:\n";
                    std::getline(std::cin, nazwaUslugi);

                    std::cout << "Podaj cene uslugi:\n";
                    std::getline(std::cin, cena);

                    std::string insertDataSQL = "INSERT INTO Hotel.Uslugi (UslugaID, NazwaUslugi, Cena) VALUES (" + uslugaID + ", '" + nazwaUslugi + "', " + cena + ");";

                    pqxx::work transaction(connection);
                    transaction.exec(insertDataSQL);
                    transaction.commit();
                }
                else if(tabela=="5"){
                    std::string s;

                    std::string goscID, pokojID,id;
                    std::cout << "Dla ktorego goscia bedzie rezerwacja:\n\n";
                    s = "SELECT * FROM Hotel.Goscie;";
                    executeSelect(connection, s);
                    std::getline(std::cin, goscID);

                    std::cout << "Dla ktorego pokoju bedzie rezerwacja:\n\n";
                    s = "SELECT * FROM Hotel.Pokoje;";
                    executeSelect(connection, s);
                    std::getline(std::cin, pokojID);

                    std::cout << "Podaj ID przypisania:\n";
                    std::getline(std::cin, id);

                    std::string insertDataSQL = "INSERT INTO Hotel.PrzypisaniePokoju (PrzypisanieID, GoscID, PokojID) VALUES (" + id + ", " + goscID + ", " + pokojID + ");";

                    pqxx::work transaction(connection);
                    transaction.exec(insertDataSQL);
                    //transaction.commit();

                    std::string dataPoczatkowa, dataKoncowa;

                    std::cout << "Podaj datę początkową (RRRR-MM-DD):\n";
                    std::getline(std::cin, dataPoczatkowa);

                    std::cout << "Podaj datę końcową (RRRR-MM-DD):\n";
                    std::getline(std::cin, dataKoncowa);

                    insertDataSQL = "INSERT INTO Hotel.Rezerwacje (RezerwacjaID, PrzypisanieID, DataPoczatkowa, DataKoncowa) VALUES (" + id + ", " + id + ", '" + dataPoczatkowa + "', '" + dataKoncowa + "');";

                    //pqxx::work transaction(connection);
                    transaction.exec(insertDataSQL);
                    transaction.commit();
                }
                else if(tabela=="6"){
                    std::string r,u,i;
                    std::string s;

                    std::cout << "Dla jakiej rezerwacji (podaj id):\n\n";
                    s = "SELECT * FROM Hotel.Rezerwacje;";
                    executeSelect(connection, s);

                    std::getline(std::cin, r);

                    std::cout << "Jaka usluge chcesz dodac:\n\n";
                    s = "SELECT * FROM Hotel.Uslugi;";
                    executeSelect(connection, s);

                    std::getline(std::cin, u);

                    std::cout << "Podaj ilosc:\n";
                    std::getline(std::cin, i);

                    std::string insertDataSQL = "INSERT INTO Hotel.UslugiRezerwacji (RezerwacjaID, UslugaID, Ilosc) VALUES (" + r + ", " + u + ", " + i + ");";

                    pqxx::work transaction(connection);
                    transaction.exec(insertDataSQL);
                    transaction.commit();

                }
                else if(tabela=="7"){
                    std::string platnoscID, rezerwacjaID, kwota, dataPlatnosci, typPlatnosci;

                    std::cout << "Podaj ID platnosci (unikalne):\n";
                    std::getline(std::cin, platnoscID);


                    std::cout << "Dla jakiej rezerwacji (podaj id):\n\n";
                    std::string s = "SELECT * FROM Hotel.Rezerwacje;";
                    executeSelect(connection, s);

                    std::getline(std::cin, rezerwacjaID);

                    std::cout << "Podaj kwote platnosci:\n";
                    std::getline(std::cin, kwota);

                    std::cout << "Podaj date platnosci (RRRR-MM-DD):\n";
                    std::getline(std::cin, dataPlatnosci);

                    std::cout << "Podaj typ platnosci (np. karta, przelew):\n";
                    std::getline(std::cin, typPlatnosci);

                    std::string insertDataSQL = "INSERT INTO Hotel.Platnosci (PlatnoscID, RezerwacjaID, Kwota, DataPlatnosci, TypPlatnosci) VALUES (" + platnoscID + ", " + rezerwacjaID + ", " + kwota + ", '" + dataPlatnosci + "', '" + typPlatnosci + "');";

                    pqxx::work transaction(connection);
                    transaction.exec(insertDataSQL);
                    transaction.commit();
                }
                
                
                std::cout << "Dane dodane pomyślnie do tabeli " << tabela << "\n";
            } else if(x == "2"){
                std::cout << "1 - Znajdź łączną kwotę płatności dla każdej rezerwacji" << std::endl;
                std::cout << "2 - Znajdź ilość rezerwacji dla każdego rodzaju pokoju, gdzie ilość rezerwacji jest większa niz 1" << std::endl;
                std::cout << "3 - Znajdź ilość rezerwacji dla każdego gościa, który wydał więcej niż 200 zlotych" << std::endl;
                std::cout << "4 - Znajdź najdroższą płatność wraz z danymi rezerwacji" << std::endl;
                std::cout << "5 - Znajdź trzy najnowsze rezerwacje" << std::endl;
                std::cout << "6 - Znajdź ilość rezerwacji dla każdego rodzaju pokoju, posortowane malejąco według ilości rezerwacji" << std::endl;
                std::cout << "7 - Znajdź sumę kwot wszystkich płatności" << std::endl;
                std::cout << "8 - Znajdź średnią pojemność pokoi we wszystkich rezerwacjach" << std::endl;
                std::cout << "9 - Znajdź największą ilość rezerwacji dla jednego gościa" << std::endl;
                std::cout << "10 - Widok rezerwacji" << std::endl;
                std::cout << std::endl;
                std::cout << "11 - tabela Goscie\n";
                std::cout << "12 - tabela TypyPokoi\n";
                std::cout << "13 - tabela Pokoje\n";
                std::cout << "14 - tabela PrzypisaniePokoju\n";
                std::cout << "15 - tabela Rezerwacje\n";
                std::cout << "16 - tabela Platnosci\n";
                std::cout << "17 - tabela Uslugi\n";
                std::cout << "18 - tabela UslugiRezerwacji\n";


                int xx;
                std::cin >> xx;
                std::string s;
                //if(xx == 1) s = "select * from SumaPlatnosci;";
                if(xx == 1) s = "SELECT r.RezerwacjaID, SUM(p.Kwota) AS SumaPlatnosci FROM Hotel.Rezerwacje r JOIN Hotel.Platnosci p ON r.RezerwacjaID = p.RezerwacjaID GROUP BY r.RezerwacjaID;";
                else if(xx == 2) s = "SELECT t.NazwaTypu, COUNT(r.RezerwacjaID) AS IloscRezerwacji FROM Hotel.TypyPokoi t JOIN Hotel.Pokoje p ON t.TypPokojuID = p.TypPokojuID JOIN Hotel.PrzypisaniePokoju pr ON p.PokojID = pr.PokojID JOIN Hotel.Rezerwacje r ON pr.PrzypisanieID = r.PrzypisanieID GROUP BY t.NazwaTypu HAVING COUNT(r.RezerwacjaID) > 1;";
                else if(xx == 3) s = "SELECT g.Imie, g.Nazwisko, COUNT(r.RezerwacjaID) AS IloscRezerwacji FROM Hotel.Goscie g JOIN Hotel.PrzypisaniePokoju pr ON g.GoscID = pr.GoscID JOIN Hotel.Rezerwacje r ON pr.PrzypisanieID = r.PrzypisanieID JOIN Hotel.Platnosci p ON r.RezerwacjaID = p.RezerwacjaID GROUP BY g.Imie, g.Nazwisko HAVING SUM(p.Kwota) > 200;";
                else if(xx == 4) s = "SELECT r.RezerwacjaID, p.PlatnoscID, p.Kwota, r.DataPoczatkowa, r.DataKoncowa FROM Hotel.Rezerwacje r JOIN Hotel.Platnosci p ON r.RezerwacjaID = p.RezerwacjaID ORDER BY p.Kwota DESC LIMIT 1;";
                else if(xx == 5) s = "SELECT RezerwacjaID, DataPoczatkowa, DataKoncowa FROM Hotel.Rezerwacje ORDER BY DataPoczatkowa DESC LIMIT 3;";
                else if(xx == 6) s = "SELECT t.NazwaTypu, COUNT(r.RezerwacjaID) AS IloscRezerwacji FROM Hotel.TypyPokoi t JOIN Hotel.Pokoje p ON t.TypPokojuID = p.TypPokojuID JOIN Hotel.PrzypisaniePokoju pr ON p.PokojID = pr.PokojID JOIN Hotel.Rezerwacje r ON pr.PrzypisanieID = r.PrzypisanieID GROUP BY t.NazwaTypu ORDER BY IloscRezerwacji DESC;";
                else if(xx == 7) s = "SELECT SUM(Kwota) AS SumaPlatnosci FROM Hotel.Platnosci;";
                else if(xx == 8) s = "SELECT AVG(Pojemnosc) AS SredniaPojemnosc FROM Hotel.Pokoje JOIN Hotel.PrzypisaniePokoju pr ON Hotel.Pokoje.PokojID = pr.PokojID JOIN Hotel.Rezerwacje r ON pr.PrzypisanieID = r.PrzypisanieID;";
                else if(xx == 9) s = "SELECT MAX(IloscRezerwacji) AS MaxIloscRezerwacji FROM ( SELECT g.Imie, g.Nazwisko, COUNT(r.RezerwacjaID) AS IloscRezerwacji FROM Hotel.Goscie g JOIN Hotel.PrzypisaniePokoju pr ON g.GoscID = pr.GoscID JOIN Hotel.Rezerwacje r ON pr.PrzypisanieID = r.PrzypisanieID GROUP BY g.Imie, g.Nazwisko ) AS IloscRezerwacjiGoście;";
                else if(xx == 10) s = "SELECT * FROM WidokRezerwacji;";
                else if(xx == 11) s = "SELECT * FROM Hotel.Goscie;";
                else if(xx == 12) s = "SELECT * FROM Hotel.TypyPokoi;";
                else if(xx == 13) s = "SELECT * FROM Hotel.Pokoje;";
                else if(xx == 14) s = "SELECT * FROM Hotel.PrzypisaniePokoju;";
                else if(xx == 15) s = "SELECT * FROM Hotel.Rezerwacje;";
                else if(xx == 16) s = "SELECT * FROM Hotel.Platnosci;";
                else if(xx == 17) s = "SELECT * FROM Hotel.Uslugi;";
                else if(xx == 18) s = "SELECT * FROM Hotel.UslugiRezerwacji;";

                executeSelect(connection, s);
            }
            if(x=="1")return 1;
            else return 2;
}



int main() {
    try {
        pqxx::connection connection("dbname=hjiqtilj user=hjiqtilj password=jhWn2Szd1QxuMer9Gjuwxwr0xVv48UuE host=bubble.db.elephantsql.com port=5432");

        if (connection.is_open()) {
            std::cout << "Polaczono z baza danych\n\n\n";
            std::string kkk = "n";
            do{
                int x = f(connection);
                
                if(x==1)std::cout << "Czy chcesz zakonczyc? [t/n]" << std::endl;
                //std::cout << kkk << std::endl;
                std::getline(std::cin, kkk);
                //std::cout << kkk << std::endl;
                //if(kkk=="t")return 0;

            }while(kkk=="n");

            
        } else {
            std::cerr << "Failed to connect to database\n";
        }
    } catch (const std::exception &e) {
        //std::cout << "yyyy";
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}

