# Backend

# Configuration

Create a file called file `backend.env` with the following content:

```
DB_URI=postgresql://username:password@db:5432/dbname
POSTGRES_USER=username
POSTGRES_PASSWORD=password
POSTGRES_DB=dbname
FRONTEND_URI=http://localhost:3000
NODE_ENV=production
```

`username`, `password`, and `dbname` affect the user credentials in your PostgreSQL database within a Docker container. Change them as needed.

FRONTEND_URI refers to the location where your frontend is running.

# Start docker containers

Run

```
npm ci
npm run dockerify
docker-compose up -d
psql -f sql/log-schema.sql postgresql://username:password@localhost:54320/dbname
```

Now you should have two docker containers, one with the application, and another with
a database.

* The application in the container listens to HTTP at port 8001. For API paths, see src/app.js.
* The database listens to port 54320 so that you can access it at `postgresql://username:password@localhost:54320/dbname`.

To develop the app, run `DB_URI=postgresql://username:password@localhost:54320/dbname npm run dev`. This command starts the backend with auto-reloading, and the app is listening to HTTP port 8000.
