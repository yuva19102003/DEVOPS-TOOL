### **1. Install Node.js**
1. Download Node.js from the [official website](https://nodejs.org/).
2. Install the appropriate version for your operating system.
3. Verify the installation:
   ```bash
   node -v
   npm -v
   ```

---

### **2. Create a Project Directory**
1. Open your terminal or command prompt.
2. Navigate to your desktop:
   ```bash
   cd ~/Desktop
   ```
3. Create a new directory for your project:
   ```bash
   mkdir my-nodejs-project
   cd my-nodejs-project
   ```

---

### **3. Initialize the Project**
1. Initialize a new Node.js project:
   ```bash
   npm init -y
   ```
   This creates a `package.json` file with default values.

---

### **4. Install Dependencies**
1. For a simple web server, install Express:
   ```bash
   npm install express
   ```
2. Install additional libraries as needed, e.g., for templating or database connectivity.

---

### **5. Create the Project Structure**
Inside your project directory, create the following folder and file structure:

```
my-nodejs-project/
├── node_modules/       # Installed dependencies (auto-generated)
├── public/             # Static files (e.g., images, CSS, JavaScript)
├── routes/             # Route handlers
│   └── index.js
├── views/              # HTML templates (if using a template engine)
│   └── index.ejs
├── controllers/        # Business logic for routes
│   └── homeController.js
├── middlewares/        # Custom middleware functions
│   └── logger.js
├── models/             # Data models (if using a database)
│   └── userModel.js
├── config/             # Configuration files (e.g., environment variables)
│   └── default.js
├── tests/              # Test files for your application
│   └── test.js
├── .gitignore          # Git ignore file
├── package.json        # Project metadata and dependencies
├── package-lock.json   # Exact dependency versions (auto-generated)
├── README.md           # Project documentation
└── index.js            # Main entry point
```

---

### **6. Populate the Files**

#### **`index.js` (Main Entry Point)**
```javascript
const express = require('express');
const app = express();
const indexRoutes = require('./routes/index');

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

// Routes
app.use('/', indexRoutes);

// Start the Server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});
```

#### **`routes/index.js`**
```javascript
const express = require('express');
const router = express.Router();
const homeController = require('../controllers/homeController');

router.get('/', homeController.getHomePage);

module.exports = router;
```

#### **`controllers/homeController.js`**
```javascript
exports.getHomePage = (req, res) => {
  res.send('Welcome to My Node.js Project!');
};
```

#### **`middlewares/logger.js`**
```javascript
module.exports = (req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
};
```

#### **`models/userModel.js`**
```javascript
// Example using Mongoose for MongoDB
const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  name: String,
  email: String,
  password: String,
});

module.exports = mongoose.model('User', UserSchema);
```

#### **`views/index.ejs`**
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Home</title>
</head>
<body>
  <h1>Hello, World!</h1>
</body>
</html>
```

#### **`public/`**
- Add static assets like CSS, JavaScript, or images here. For example:
  - `public/css/style.css`
  - `public/js/script.js`
  - `public/images/`

#### **`.gitignore`**
```plaintext
node_modules/
.env
```

---

### **7. Run Your Project**
1. Start the server:
   ```bash
   node index.js
   ```
2. Visit `http://localhost:3000` in your browser to see the output.

---

### **8. Optional Enhancements**
1. Use `nodemon` for auto-restarting the server:
   ```bash
   npm install -g nodemon
   nodemon index.js
   ```
2. Write tests in the `tests/` folder to ensure code quality.
3. Document your project in `README.md`.

---

This setup is modular, scalable, and ready for extensions like database integration, API development, and testing.