use context essentials2021
include shared-gdrive("dcic-2021", "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")
include gdrive-sheets
include data-source

ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"

kWh-wealthy-consumer-data =
  load-table: component, energy
    source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
    sanitize energy using string-sanitizer 
    sanitize component using string-sanitizer
end

#Sanert tabell
print(kWh-wealthy-consumer-data)

#Funksjon for å gjøre string til tall fra kolonnen "energy" 
fun energy-to-number(str :: String) -> Number:
  doc: "if str is not a numeric string, default to 0."
  cases(Option) string-to-number(str):
    | some(a) => a
    | none => 0
  end
  
where:
energy-to-number("") is 0
energy-to-number("48") is 48
end

#Tabell med tall
transformed-table = transform-column(kWh-wealthy-consumer-data, "energy", energy-to-number)

print(transformed-table)

#Beregning av energiforbruket for bilbruken 
fun car-energy-per-day(distance-travelled-per-day, distance-per-unit-of-fuel, energy-per-unit-of-fuel):
(distance-travelled-per-day / 
                            distance-per-unit-of-fuel) * 
                                        energy-per-unit-of-fuel
where:
  car-energy-per-day(15, 5, 6) is 18
end

distance-travelled-per-day = 15
distance-per-unit-of-fuel = 5
energy-per-unit-of-fuel = 6

#Slet med denne. Tror det ble riktig. Ny funksjon for å få vist riktig energiforbruk for bil i visualiseringen.
fun energy-to-number-with-car(str :: String) -> Number:
   cases(Option) string-to-number(str):
    | some(a) => a
    | none => car-energy-per-day(15, 5, 6)
  end
where:
energy-to-number("") is 0
  energy-to-number("46") is 46
end

#Endelig utgave
transformed-table-with-car = transform-column(kWh-wealthy-consumer-data, "energy", energy-to-number-with-car)

print(transformed-table-with-car)

#Visualisering av bilforbruket
bar-chart(transformed-table-with-car, "component", "energy")