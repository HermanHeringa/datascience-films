import tmdbsimple as tmdb
tmdb.API_KEY = '5242b07e212995cf87db7a1d9c52ae55' # store this somewhere before pushing to git. os.getenv()
import requests


tmdb.REQUESTS_SESSION = requests.Session()


search = tmdb.Search()
response = search.movie(query='vietnam war')
for s in search.results:
    print(s)


# https://api.themoviedb.org/3/search/multi?api_key=5242b07e212995cf87db7a1d9c52ae55&language=en-US&query=vietnam%20war&page=1&include_adult=true

