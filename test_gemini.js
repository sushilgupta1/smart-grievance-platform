const fs = require('fs');

fetch("https://generativelanguage.googleapis.com/v1beta/models?key=AIzaSyB0sGfm1JiVWdA-yBKVu1xzn9RO5LNXHm0")
    .then(res => res.text())
    .then(text => {
        fs.writeFileSync("gemini_models_raw.txt", text);
        console.log("Done fetching root models!");
    })
    .catch(err => console.error("Error:", err));
