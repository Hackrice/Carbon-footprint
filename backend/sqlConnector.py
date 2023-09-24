import mysql.connector

class sqlConnector:
    def __init__(self):
        self.host = "159.65.240.201"
        self.port = 3000
        self.user = "eph"
        self.password = "Password123!"
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


    def insert_data(self, vehicle_type, commute_miles, commute_time, electrical_usage, state, city):
        cursor = self.connection.cursor()


                # SQL query to insert data into the table
        insert_query = "INSERT INTO your_table_name (vehicle_type, commute_miles, commute_time, electrical_usage, state, city) VALUES (%s, %s, %s, %s, %s, %s)"

        try:
            # Execute the insert query for each set of data
            # check statement
            data = (vehicle_type, commute_miles, commute_time, electrical_usage, state, city)

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
            self.connection.close()


