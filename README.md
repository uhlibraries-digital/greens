# Greens

[![Code Climate](https://codeclimate.com/github/uhlibraries-digital/greens/badges/gpa.svg)](https://codeclimate.com/github/uhlibraries-digital/greens)
[![Build Status](https://travis-ci.org/uhlibraries-digital/greens.svg?branch=master)](https://travis-ci.org/uhlibraries-digital/greens)

Greens is a rails application that is used as a ARK minter and resolver

## Mainual Installation

Install Ruby 2.5

Greens uses the [config](https://github.com/railsconfig/config) gem for application settings. Update the `config/settings.yml` file with your configuration setup. You can also update the environment files in `config/settings/` to overwrite the default settings.

Install gems and build the app

```bash
gem install bundler
bundle install
rake db:setup
```

Once setup you can continue to run the rails server according to your system environment.

## Upgrade

If you are upgrading from a previous version of Greens

1. Upgrade to Ruby 2.5 or later
2. cd into your greens installation
3. Run `git pull` if you cloned from the repository
4. `bundle install`
5. `rake db:migrate`
6. `rake greens:migrate`
7. Copy your default environment settings from `config/app.yml` into `config/settings.yml`
8. Rename `api-key` to `apikey` in `config/settings.yml`
9. Remove `noid_state_file` setting in `config/settings.yml`
10. If you have additional environment variables in `app.yml` you can place those settings in the appropriate `config/settings/` location.
11. Delete `config/app.yml` file

## Usage

Greens can be used as a Name Mapping Authority Hostport (NMAH) by having a URL in the format of `http://example.com/ark:/12345/57x43/`. A request for a metadata erc record describing the object identified can be done by adding a '?' to the end of the request string `http://example.com/ark:/12345/57x43/?`. You can view all the minted identifiers by going to `http://example.com/ids`.

## Suffix Passthrough

Suffix Passthrough allows you to add any suffix to the identifier which will be added to the end of the identifiers `erc.where` url. For example having the ARK `ark:/12345/57x43` with `erc.where` equal to `http://objects.com` will result in the ARK URL `http://example.com/ark:/12345/57x43/object4/item2/thumbnail.jpg` redirecting to `http://objects.com/object4/item2/thumbnail.jpg`.

### Minting/Updating Identifiers

Greens uses an REST API to mint, update, and destroy ARK identifiers.

To authenticate with these API calls, you will need to provide a application key which should be provided in a normal HTTP header called `api-key`. This key is set in the `config/app.yml` file.

**Example**

```
api-key: Dh7KgcDfUMeRmivTdSh1VY2i79qyigofckCiAivwjti89eAwkaKmPU0FH6NIs74
```

HTTP status code returned by a successful API will usually be 200 OK. All successful responses will return a JSON-encoded string.

#### Mint

/api/v1/arks/mint(/prefix)

Method: GET

Returns the minted identifier. /prefix is optional and allows every minted identifier to begin with the prefix string.

/api/v1/arks/mint(/prefix)

Method: POST

Returns the minted ark identifier. /prefix is optional and allows every minted identifier to begin with the prefix string.

| Parameter | Description |
| --------- | ----------- |
| who | The name of the entity (person, organization, or service) responsible for creating the content or making it available. |
| what | A name or other human-oriented identifier given to the resource. |
| when | A point or period of time important to the lifecycle of the resource. |
| where | The identifier's target URL or location. |

#### Update

/api/v1/id/{ark identifier}

Method : PUT

Returns the updated object erc

| Parameter | Description |
| --------- | ----------- |
| who | The name of the entity (person, organization, or service) responsible for creating the content or making it available. |
| what | A name or other human-oriented identifier given to the resource. |
| when | A point or period of time important to the lifecycle of the resource. |
| where | The identifier's target URL or location. |

#### Destroy

/api/v1/id/{ark identifier}

Method: DELETE

Deletes the given identifier. This can not be un-done.

## License

[MIT License](LICENSE.txt)
