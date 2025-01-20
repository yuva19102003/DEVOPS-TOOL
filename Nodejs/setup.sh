#!/bin/bash

# Variables
PROJECT_NAME="my-nodejs-project"
ROOT_DIR="$PWD/$PROJECT_NAME"

# Create project directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

# Initialize Node.js project
npm init -y

# Install Express.js
npm install express

# Create project structure
mkdir -p public/css public/js public/images \
         routes \
         views \
         controllers \
         middlewares \
         models \
         config \
         tests

# Create essential files
cat <<EOL > index.js
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
  console.log(\`Server is running at http://localhost:\${PORT}\`);
});
EOL

cat <<EOL > routes/index.js
const express = require('express');
const router = express.Router();
const homeController = require('../controllers/homeController');

router.get('/', homeController.getHomePage);

module.exports = router;
EOL

cat <<EOL > controllers/homeController.js
exports.getHomePage = (req, res) => {
  res.send('Welcome to My Node.js Project!');
};
EOL

cat <<EOL > middlewares/logger.js
module.exports = (req, res, next) => {
  console.log(\`\${req.method} \${req.url}\`);
  next();
};
EOL

cat <<EOL > models/userModel.js
// Example using Mongoose for MongoDB
const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  name: String,
  email: String,
  password: String,
});

module.exports = mongoose.model('User', UserSchema);
EOL

cat <<EOL > views/index.ejs
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
EOL

cat <<EOL > public/css/style.css
/* Add your CSS styles here */
body {
  font-family: Arial, sans-serif;
}
EOL

cat <<EOL > public/js/script.js
// Add your JavaScript code here
console.log('Script loaded');
EOL

cat <<EOL > .gitignore
node_modules/
.env
EOL

cat <<EOL > README.md
# $PROJECT_NAME

This is a basic Node.js project template set up using Express.js.

## Features
- Organized folder structure
- Example routes, controllers, and middleware
- Static files and template engine support

## Setup
1. Clone the repository:
   \`\`\`
   git clone <repo-url>
   cd $PROJECT_NAME
   \`\`\`

2. Install dependencies:
   \`\`\`
   npm install
   \`\`\`

3. Run the server:
   \`\`\`
   node index.js
   \`\`\`

4. Open \`http://localhost:3000\` in your browser.

## License
MIT
EOL

# Completion message
echo "Node.js project '$PROJECT_NAME' has been set up successfully!"
echo "Navigate to '$ROOT_DIR' and start coding!"