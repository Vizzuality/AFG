# AFG #

## Installation ##

### Requirements ###

  - Ruby 1.8.7x (not working in 1.9.x)
  - Rails 3 RC
  - wkhtmltopdf

### Bundler and dependencies ###

First of all, install bundler:

    sudo gem install bundler
    
Then:

    bundle install
    
And finally, migrate the databases:

    rake db:migrate

### Installing PDFKit and wkhtmltopdf ###

In order to generate pdf's it's necessary to install an external dependency from

http://code.google.com/p/wkhtmltopdf/

Once you have installed the binary, create a symlink from it to /usr/local/bin/wkhtmltopdf which is the path where Rails is gonna search the binary.

### Example data ###

If you are in development mode and want some data:

    rake db:seed
    
### Importing real data ###
    
Or you can import real data:

    rake afg:import_data


## Setting an admin password ##

By default, if you don't set a password for the administration, the defaults are:

    User: afg
    Password: afg
    
If you want to set a new password (the User can't be changed), visit:

   http://your.host/authorizations
   
And then, set the new password.


## Taxonomy JSON API ##

The base URL of the JSON taxonomy API is:

<http://localhost:3000/api/taxonomy>

### Getting available kingdoms ###

<http://localhost:3000/api/taxonomy>

Response:

    {"kingdoms":[{"count":10,"add_url":null,"name":"Animalia","id":1},{"count":1,"add_url":"http://localhost:3000/entries?type=Kingdom&id=Plantae","name":"Plantae","id":111}]}
    
### Getting available phylums from a kingdom ###

<http://localhost:3000/api/taxonomy?id=1>

Response:

    {"phylums":[{"count":8,"add_url":"http://localhost:3000/entries?type=Phylum&id=Arthropoda","name":"Arthropoda","id":9},{"count":2,"add_url":"http://localhost:3000/entries?type=Phylum&id=Annelida","name":"Annelida","id":2}]}

### Getting the other taxonomies ###

All taxonomies can be fetched trough requests using the `id` parameter.

### Attributes ####

There are four attributes in a taxonomy object:

  - `count`: the number of species belonging to the taxonomy
  - `add_url`: if null means that the taxonomy has been added to the current guide. If not, is the url to add the taxonomy to the current guide
  - `name`: the name of the taxonomy
  - `id`: the internal identifier



## Landscapes JSON API ##

The base URL of the API is:

<http://localhost:3000/api/maps/features>

The action supports three parameters:

  - `guide_id`
  - `species_id`
  - `landscape_id`
  
Returns a hash serialized in JSON format with two keys: `landscapes` and `occurrences`.

For example:

<http://localhost:3000/api/maps/features?species_id=1>

Response:

    {"landscapes":[{"add_url":"http://localhost:3000/entries?type=Landscape&id=1","lat":"1418327.72363306","url":"http://localhost:3000/landscapes/1-antartic-zone","guides_count":0,"picture":"/system/images/1/small/open-uri20100825-41226-1pktk3d-0.?1282759412","name":"Antartic Zone","lon":"0","description":"All the antartic, just for tests"},{"add_url":"http://localhost:3000/entries?type=Landscape&id=2","lat":"-1269557.87833021","url":"http://localhost:3000/landscapes/2-spanish-base","guides_count":1,"picture":"/system/images/2/small/open-uri20100825-41226-8bf90t-0.?1282759413","name":"Spanish base","lon":"316536.330297898","description":"Spanish scientific observatory"}],"occurrences":[{"lat":"1214862.48686366","lon":"-2501910.54506187"},{"lat":"1240995.34228873","lon":"-2489051.58602589"},{"lat":"-917564.029841617","lon":"2448525.67471427"},{"lat":"-1316124.94597136","lon":"361285.829264033"},{"lat":"-1314918.39929627","lon":"323785.381957426"},{"lat":"-1290073.09567433","lon":"309719.147932137"},{"lat":"-1349377.77616217","lon":"250903.666365259"},{"lat":"-1712417.04507405","lon":"14944.0371550031"}]}

### Attributes ###

These are the attributes for the landscapes:

  - `add_url`: if null means that the landscape has been added to the current guide. If not, is the url to add the landscape to the current guide
  - `name`: the name of the landscape
  - `lat`: the latitude
  - `lon`: the longitude
  - `url`: the application url of the landscape
  - `guides_count`: the number of guides in which has been included
  - `picture`: a url from a picture
  - `description`: the description of the landscape

