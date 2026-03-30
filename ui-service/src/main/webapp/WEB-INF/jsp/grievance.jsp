<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <style>
        body {
            font-family: Arial;
            background: #f4f6f9;
            margin: 0;
        }

        .navbar {
            background: #2c3e50;
            color: white;
            padding: 15px;
        }

        .container {
            padding: 20px;
        }

        .card {
            background: white;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
        }

        input, button {
            padding: 8px;
            margin: 5px;
        }

        button {
            background: #3498db;
            color: white;
            border: none;
            cursor: pointer;
        }

        ul {
            list-style: none;
            padding: 0;
        }

        li {
            background: white;
            margin: 5px;
            padding: 10px;
            border-radius: 5px;
        }
    </style>
</head>

<body>

<div class="navbar">
    <h2>Grievance Dashboard</h2>
</div>

<div class="container">

    <div class="card">
        <h3>Create Grievance</h3>
        <input id="title" placeholder="Title">
        <input id="description" placeholder="Description">
        <button onclick="submitGrievance()">Submit</button>
    </div>

    <div class="card">
        <h3>My Grievances</h3>
        <button onclick="loadMyGrievances()">Refresh</button>
        <ul id="list"></ul>
    </div>
    <div class="card" id="adminSection" style="display:none;">
    <h3>Admin Panel</h3>

    <button onclick="loadAll()">Load All Grievances</button>
    <input id="filterStatus" placeholder="Filter status (OPEN/RESOLVED)">
    <button onclick="filterByStatus()">Filter</button>

    <ul id="adminList"></ul>
</div>

</div>

<script>
function submitGrievance() {

    const token = localStorage.getItem("token");

    fetch("http://localhost:8085/grievance", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
        },
        body: JSON.stringify({
            title: document.getElementById("title").value,
            description: document.getElementById("description").value
        })
    })
    .then(res => res.json())
    .then(data => {
        alert("Submitted!");
        loadMyGrievances();
    });
}

function loadMyGrievances() {

    const token = localStorage.getItem("token");

    fetch("http://localhost:8085/grievance/my", {
        headers: {
            "Authorization": "Bearer " + token
        }
    })
    .then(data => {

        console.log("API RESPONSE:", data);

        let list = document.getElementById("list");
        list.innerHTML = "";

        // 🔥 Fix: ensure array
        const grievances = Array.isArray(data) ? data : [data];

        grievances.forEach(g => {
            let li = document.createElement("li");

            li.innerHTML = `
                <b>ID:</b> ${g.id} <br>
                <b>Title:</b> ${g.title} <br>
                <b>Status:</b> ${g.status} <br>
                <b>Remarks:</b> ${g.remarks ? g.remarks : 'None'} <br>
                <hr>
            `;

            list.appendChild(li);
        });
    });
}
function getRole() {
    const token = localStorage.getItem("token");

    if (!token) return null;

    const payload = JSON.parse(atob(token.split('.')[1]));
    return payload.role;
}
</script>
<script>
window.onload = function() {
    const role = getRole();

    if (role === "ADMIN") {
        document.getElementById("adminSection").style.display = "block";
    }
}
</script>
<script>
function loadAll() {

    const token = localStorage.getItem("token");

    fetch("http://localhost:8085/grievance/all", {
        headers: {
            "Authorization": "Bearer " + token
        }
    })
     .then(res => res.json())
    .then(data => {

        let list = document.getElementById("adminList");
        list.innerHTML = "";

        const grievances = Array.isArray(data) ? data : [data];

        grievances.forEach(g => {

            let li = document.createElement("li");

            li.innerHTML = `
                <b>ID:</b> ${g.id} <br>
                <b>Title:</b> ${g.title} <br>
                <b>Description:</b> ${g.description} <br>
                <b>Status:</b> ${g.status} <br>
                <b>User:</b> ${g.userEmail} <br>
                <b>Assigned To:</b> ${g.assignedTo || 'Not Assigned'} <br>
                <b>Remarks:</b> ${g.remarks || 'None'} <br>

                <button onclick="assign(${g.id})">Assign</button>
                <button onclick="resolve(${g.id})">Resolve</button>
                <hr>
            `;

            list.appendChild(li);
        });
    }); 
}
</script>
<script>
function assign(id) {
    const token = localStorage.getItem("token");

    fetch(`http://localhost:8085/grievance/assign/${id}?admin=admin@gmail.com`, {
        method: "PUT",
        headers: {
            "Authorization": "Bearer " + token
        }
    })
    .then(() => {
        alert("Assigned!");
        loadAll();
    });
}

function resolve(id) {
    const token = localStorage.getItem("token");

    fetch(`http://localhost:8085/grievance/status/${id}?status=RESOLVED&remarks=Done`, {
        method: "PUT",
        headers: {
            "Authorization": "Bearer " + token
        }
    })
    .then(() => {
        alert("Resolved!");
        loadAll();
    });
}
</script>
<script>
function filterByStatus() {

    const token = localStorage.getItem("token");
    const status = document.getElementById("filterStatus").value;

    fetch(`http://localhost:8085/grievance/status?status=${status}`, {
        headers: {
            "Authorization": "Bearer " + token
        }
    })
    .then(res => res.json())
    .then(data => {

        let list = document.getElementById("adminList");
        list.innerHTML = "";

        data.forEach(g => {
            let li = document.createElement("li");
            li.innerText = g.title + " - " + g.status;
            list.appendChild(li);
        });
    });
}
</script>

</body>
</html>