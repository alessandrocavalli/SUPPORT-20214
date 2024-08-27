## SUPPORT-20214
### Testing the query performances using C 7.20.1 and MSSQL 2019 
1. Start the docker application docker compose up
2. Deploy model and start the multiple instances using start-many.sh
3. Find the MSSQL jdbc driver in this folder and configure your preferred SQL tool.
  1. JDBC URL : jdbc:sqlserver://localhost:1433;TrustServerCertificate=True
  2.  Username : sa
  3. Password : CamundaMSQL2019!
4. Start the External Client project application (optional, just to see that when the tasks are executed the time is decreasing)
5. Start measuring the time for the queries in the QUERY folder
