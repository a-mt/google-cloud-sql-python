# Connect a Google SQL Cloud instance to Python

## Create a Google SQL Instance

* Access [Google Cloud Console](https://console.cloud.google.com/)  
  * If you don't have an account, you can have a [free trial](https://cloud.google.com/free/) (300$ credit for free)
  * Choose a project or Create a new one
  * In the left panel, go to `Storage > SQL`
  * `Create an instance`. Choose MySQL, Second Generation
  * In the `Overview` tab of the instance's details, take note of the Instance connection name
  * Go to the tab `Users` and create a MySQL user account
  * Go to the tab `Databases` and create a MySQL database

* Enable [Cloud SQL Administration API](https://console.cloud.google.com/flows/enableapi?apiid=sqladmin&redirect=https://console.cloud.google.com&_ga=2.131986251.-557403291.1515535598) for your project
* Enable [Cloud SQL API](https://console.cloud.google.com/apis/api/sql-component.googleapis.com/overview) for your project
* Go to [service accounts](https://console.cloud.google.com/iam-admin/serviceaccounts/?_ga=2.61265896.-557403291.1515535598)
  * Select your project
  * `Create service account`
  * Select role `Cloud SQL > Cloud SQL Client`
  * Check `Furnish a new private key > JSON`
  * `Create`. Download the JSON file

* Server-side:
  * Upload your JSON file
  * Create a `.env` file and replace with your own credentials:

        DATABASE_URL="mysql+pymysql://<MYSQL_NAME>:<MYSQL_USER>@127.0.0.1/<MYSQL_DB>"
        CLOUDSQL_INSTANCE="<INSTANCE_NAME>"
        CLOUDSQL_CREDENTIAL="<FILE>.json"

## Run

* Install dependencies

      sudo pip install -r requirements.txt

* Download Google Cloud SQL Proxy

      wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
      chmod +x cloud_sql_proxy

* Start the script

      python app.py

[Source](https://cloud.google.com/sql/docs/mysql/connect-admin-proxy)

## Deploy on Heroku

* Commit your diffs with Git
* Push to Heroku

    ``` bash
    heroku login
    heroku create
    heroku buildpacks:add https://github.com/weibeld/heroku-buildpack-run.git
    heroku buildpacks:add heroku/python
    ```

    ``` bash
    # Put your own JSON filename (Google Cloud SQL Service Account)
    IFS='%'
    JSON=".ca03e24da771.json"
    heroku config:set UPLOAD1="$JSON="$(printf "%q" `cat $JSON`)
    ```

    ``` bash
    # Set the environment variables that are in .env
    heroku config:set DATABASE_URL=...
    ```

    ``` bash
    git push heroku master
    # Check your JSON has been uploaded
    heroku run 'ls -la'
    ```

    ``` bash
    heroku ps:scale web=1
    heroku open
    ```
