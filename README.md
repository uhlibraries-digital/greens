# Greens

Greens is a rails application that is used as a ARK minter and resolver

## Installation

Install Ruby 2.1 or higher and Rails 4.2 or higher

Copy the appropriate `database.yml` file for your setup. For SQLite3, `cp config/database.yml.sqlite3 config/database.yml`. For MySQL, `cp config/database.yml.mysql config/database.yml`. Update the file to match your configuation.

Copy the `app.yml` file, `cp config/app.yml.sample config/app.yml`. Update the file with your configuration setup.

Install gems and build the app

```bash
gem install bundler
bundle install
rake db:migrate
```

Once setup you can continue to run the rails server according to your system environment.

## Usage

Greens can be used as a Name Mapping Authority Hostport (NMAH) by having a URL in the format of `http://example.com/ark:/12345/57x43/`. A request for a metadata erc record describing the object identified can be done by adding a '?' to the end of the request string `http://example.com/ark:/12345/57x43/?`. You can view all the minted identifiers by going to `http://example.com/ids`.

### Minting/Updating Identifiers

Greens uses an API to mint, update, and destroy ARK identifiers.

To authenticate with these API calls, you will need to provide a application key which should be provided in a normal HTTP header called `api-key`. This key is set in the `config/app.yml` file.

**Example**

```
api-key: Dh7KgcDfUMeRmivTdSh1VY2i79qyigofckCiAivwjti89eAwkaKmPU0FH6NIs74
```

HTTP status code returned by a successfull API will usually be 200 OK. All successfull responses will return a JSON-encoded string.

#### Mint

/api/v1/arks/mint

Method: GET

Returns the minted identifier

/api/v1/arks/mint

Method: POST

Returns the minted identifier

| Parameter | Description |
| --------- | ----------- |
| who | The name of the entity (person, organization, or service) responsible for creating the content or making it available. | 
| what | A name or other human-oriented identifier given to the resource. |
| when | A point or period of time important to the lifecycle of the resource. |
| where | The identifier's target URL or location. |

#### Update

/api/v1/id/ark:/{identifier}

Method : PUT

Returns the updated object erc

| Parameter | Description |
| --------- | ----------- |
| who | The name of the entity (person, organization, or service) responsible for creating the content or making it available. | 
| what | A name or other human-oriented identifier given to the resource. |
| when | A point or period of time important to the lifecycle of the resource. |
| where | The identifier's target URL or location. |

#### Destroy

/api/vi/id/ark:/{identifier}

Method: DELETE

Deletes the given identifier. This can not be un-done.

## License

[MIT License](LICENSE.txt)