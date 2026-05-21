component {

    this.name = "LuceeMySQLApp_v2";
    this.applicationTimeout = createTimeSpan(0,1,0,0);

    dbName = server.system.environment.DB_NAME ?: "luceeapp";
    dbUser = server.system.environment.DB_USER ?: "luceeapp"; 
    dbPass = server.system.environment.DB_PASSWORD ?: "";
    this.datasource = "mydb";
    this.datasources = {
        "mydb" = {
            class: "com.mysql.cj.jdbc.Driver", // Driver moderno para MySQL
            bundleName: "com.mysql.cj",        // Opcional, ajuda o Lucee a localizar o bundle OSGi
            connectionString: "jdbc:mysql://db:3306/#dbName#?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&connectTimeout=10000",
            username: dbUser,
            password: dbPass
        }
    };

}