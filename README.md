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

http://localhost:3000/landscapes.json

The request returns a JSON array that includes all the landscapes, with some data such as name, description, a picture, and so on...