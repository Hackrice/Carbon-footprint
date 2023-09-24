import mysql.connector

class sqlConnector:
    def __init__(self):
        self.host = "159.65.240.201"
        self.port = 3000
        self.user = "seb"
        self.password = "!hackrice23Ka"
        self.database = "dbo"


        # Create a connection to the MySQL server
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                port=self.port,
                user=self.user,
                password=self.password,
                database=self.database
            )

            if self.connection.is_connected():
                print("Connected to MySQL database")
        except mysql.connector.Error as err:
            print(f"Error: {err}")


    def insert_data(self, emailId, state, city, vehicle_type, commute_miles, commute_time, electrical_usage):
        cursor = self.connection.cursor()


         # SQL query to insert data into the table
        insert_query = "INSERT INTO CustomerDataForm ( Email_ID, State, City, Vehicle_Type, Commute_Miles, Commute_Time, Electrical_Usage) VALUES (%s, %s, %s, %s, %s, %s, %s)"

        try:
            # Execute the insert query for each set of data
            # check statement
            data = (emailId, state, city, vehicle_type, commute_miles, commute_time, electrical_usage)
            cursor.execute(insert_query, data)

            # Commit the changes to the database
            self.connection.commit()
            print("Data inserted successfully!")

        except mysql.connector.Error as error:
            # Handle any errors that occur during the insert
            print("Error inserting data:", error)

        finally:
            # Close the cursor and connection
            cursor.close()
            # self.connection.close()
        
        return {"status": 200}


    def getCityYearEmissions(self, state, year):
    
        cursor = self.connection.cursor()

        # Define the parameters for the stored procedure
        params = (state, year)

        # Call the stored procedure
        cursor.callproc("GET_CityYearEmissions", params)
        try:
            for result in cursor.stored_results():
                rows = result.fetchall()
                return rows

        except mysql.connector.Error as err:
            print(f"Error: {err}")

        finally:
            # Close the cursor and connection
            if cursor:
                cursor.close()
            if self.connection.is_connected():
                # self.connection.close()
                print("MySQL connection closed")


    def getCityMonthYearPercentile(self, month, year):

        cursor = self.connection.cursor()

        # Define the parameters for the stored procedure
        params = (month, year)

        # Call the stored procedure
        cursor.callproc("GET_CityMonthYearPercentile", params)
        try:
            for result in cursor.stored_results():
                rows = result.fetchall()
                return rows

        except mysql.connector.Error as err:
            print(f"Error: {err}")

        finally:
            # Close the cursor and connection
            if cursor:
                cursor.close()
            if self.connection.is_connected():
                # self.connection.close()
                print("MySQL connection closed")

