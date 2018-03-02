
#----------------------------------------------------------
# Download Google Cloud SQL Proxy
#----------------------------------------------------------

if [ ! -f cloud_sql_proxy ]; then
    wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
    chmod +x cloud_sql_proxy
fi

#----------------------------------------------------------
# Upload files using heroku config vars (text only)
#----------------------------------------------------------
# To upload ".ca03e24da771.json":
# JSON=".ca03e24da771.json"
# heroku config:set UPLOAD1="$JSON="$(printf "%q" `cat $JSON`)
#
# To list distant files:
# heroku run ls -la
#
# To remove ".ca03e24da771.json":
# heroku config:set UPLOAD1=".ca03e24da771.json="
#
# To clear out configs (will keep the uploaded file):
# heroku config:unset UPLOAD1
#----------------------------------------------------------

IFS=$' \t\n'

for file in $ENV_DIR"/UPLOAD"*; do
    IFS='%'
    if [ -f $file ]; then

        upload=$(cat $file)
        filename=${upload%%=*}
        declare -a content="( ${upload#*=} )"

        echo "Uploading" $filename
        echo $content > "$filename"

        # The file only contains EOF, delete it
        find "$filename" -size 1 -delete
    fi
    IFS=$' \t\n'
done