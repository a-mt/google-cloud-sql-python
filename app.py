import os
from dotenv import load_dotenv
import sqlalchemy
import web
web.config.debug = False

# Load .env file
pwd = os.path.dirname(__file__)
dotenv_path = os.path.join(pwd, '.env')
load_dotenv(dotenv_path)

# Load database engine
engine = sqlalchemy.create_engine(os.environ.get("DATABASE_URL"), pool_recycle=3600, connect_args={'connect_timeout': 10})

# Web server app
urls = (
    '/.*', "index"
)
app = web.application(urls, globals())
class index:
    def GET(self):
        # Exec MySQL
        try:
            connection = engine.connect()
            result = connection.execute("select 1").fetchall()
            connection.close()
            return result

        except Exception as e:
            # https://github.com/webpy/webpy/blob/master/web/webapi.py#L15
            web.ctx.status = "500 Internal Server Error"
            return str(e)

if __name__ == "__main__":

    # Start Google Cloud SQL Proxy
    os.system('./cloud_sql_proxy -instances=' + os.environ.get('CLOUDSQL_INSTANCE') + '=tcp:3306 -credential_file=' + os.environ.get('CLOUDSQL_CREDENTIAL') + ' &')

    # Start web server
    app.run()