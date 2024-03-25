# Turbochat

## Features

- Real-time Messaging: Utilizes Turbo and Stimulus to provide users with instant messaging capabilities, ensuring fast and responsive communication.
- Chatrooms and Direct Messaging: Users can engage in both group conversations through chatrooms and one-on-one conversations via direct messaging.
- User Status: Displays user status indicators to show availability or activity, enhancing the overall messaging experience.
- ActiveStorage Integration: Implemented ActiveStorage for user avatar and attachment capabilities, allowing users to personalize their profiles and share files seamlessly.
- Search and Joinable Rooms: Users can easily search for and join existing chatrooms, facilitating community engagement and collaboration.
- Admin Functionality: Admin users have the ability to create chatrooms, manage user permissions, and moderate conversations as needed, ensuring a safe and organized messaging environment.

## Prerequisites

Before getting started, ensure that you have the following installed:

- Ruby (version 3.0.2)
- Rails (version 7.1.3 or higher)
- PostgreSQL (with appropriate configurations)
- Yarn

## Installation

1. Clone this repository to your local machine:
```yaml
git clone <repository-url>
```
2. Navigate into the project directory:
```yaml
cd Demo-Turbochat
```
3. Install the required Ruby gems:
```yaml
bundle install
```
4. Install JavaScript dependencies:
```yaml
yarn install
```
5. Remove the existing credentials file if it exists:
```yaml
rm config/credentials.yml.enc
```
6. Run the following command in your terminal to create a new encrypted credentials file:
```yaml
rails credentials:edit
```
This will open the credentials file in your default editor.

7. Update the `DB_NAME`, `DB_USERNAME`, and `DB_PASSWORD` values for the development, test, and production environments according to your database setup within the credentials file.

## Database Credentials

```yaml
DB_NAME:
  dev_db: turbo_dev1
  test_db: turbo_test1
  prod_db: turbo_prod1
DB_USERNAME:
  dev_db: turbo_dev1
  test_db: turbo_test1
  prod_db: turbo_prod1
DB_PASSWORD:
  dev_db: password123
  test_db: password1234
  prod_db: password12345
```
Once you've updated the database credentials, configured the database connection, and created the necessary databases, you're ready to run the application. Start by launching the Rails console:
```yaml
rails console
```
Then, launch the PostgreSQL command line interface:
```yaml
psql
```
Within the PostgreSQL command line interface, create the required databases for turbo_dev1 and turbo_test1:
```yaml
CREATE user turbo_dev1 WITH PASSWORD 'password123';
CREATE user turbo_test1 WITH PASSWORD 'password123';
ALTER turbo_dev1 WITH CREATEDB;
ALTER turbo_test1 WITH CREATEDB;
```
After creating the databases, you can exit the PostgreSQL command line interface:
```yaml
\q
```
Before starting the application, ensure that you have created the databases for development and testing environments. Run the following commands in your terminal:
```yaml
rails db:create
```
Then: 
```yaml
rails db:migrate
```

## Running the Application

To start the Rails server, run the following command:
```yaml
rails s
```
The application will be accessible at `http://localhost:3000`.

## Demo

![image](https://github.com/BinhNguyenDang/Demo-Turbochat/assets/146049423/a52bbac1-4501-472a-94a0-81524fb89ec2)

![image](https://github.com/BinhNguyenDang/Demo-Turbochat/assets/146049423/d42ab212-1b8c-45b7-937b-7d84e9d9e5fd)

![image](https://github.com/BinhNguyenDang/Demo-Turbochat/assets/146049423/25a8382f-ec0c-4ec0-80b4-0f57812147bc)








