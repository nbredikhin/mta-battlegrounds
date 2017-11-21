local LOCAL = true

if LOCAL then
    unix_socket = false
    host = "localhost"
    dbname = "main"
    user = "root"
    password = ""
else
    unix_socket = false
    host = "91.134.194.237"
    port = "3306"
    dbname = "gs4955"
    user = "gs4955"
    password = "G52QfSRXDvpZhr"
end
