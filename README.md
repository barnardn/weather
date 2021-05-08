# weather

A simple command line application that fetches the weather conditions for a given zip code.

```
USAGE: weather-command [--just-temp] [--metric] <zip-code>

ARGUMENTS:
  <zip-code>              5 digit zip code

OPTIONS:
  -j, --just-temp         returns only the temperature
  -m, --metric            display metric values
  -h, --help              Show help information.
```

This app assumes that you have an envrironment variable named `OPENWEATHERMAP_API` set to contain your API key for the 
openweather map service. You can get a free api key [from openweathermap.org](https://openweathermap.org/api)




