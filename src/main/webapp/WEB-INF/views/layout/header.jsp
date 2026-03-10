<!DOCTYPE html>
<html lang="en">

<head>

    <!-- Meta -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>SB Admin 2</title>

    <!-- Fonts -->
    <link href="${pageContext.request.contextPath}/assets/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">

    <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">

    <!-- Styles -->
    <link href="${pageContext.request.contextPath}/assets/css/sb-admin-2.min.css" rel="stylesheet">

    <link href="${pageContext.request.contextPath}/assets/vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">

</head>

<body id="page-top">

<div id="wrapper">

    <!-- ================= SIDEBAR ================= -->
    <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

        <!-- Brand -->
        <a class="sidebar-brand d-flex align-items-center justify-content-center" href="#">

            <div class="sidebar-brand-icon rotate-n-15">
                <i class="fas fa-laugh-wink"></i>
            </div>

            <div class="sidebar-brand-text mx-3">
                SB Admin <sup>2</sup>
            </div>

        </a>

        <hr class="sidebar-divider my-0">

        <!-- Dashboard -->
        <li class="nav-item">

            <a class="nav-link" href="#">

                <i class="fas fa-fw fa-tachometer-alt"></i>
                <span>Dashboard</span>

            </a>

        </li>

        <hr class="sidebar-divider">

        <!-- Heading -->
        <div class="sidebar-heading">
            Interface
        </div>

        <!-- Tables -->
        <li class="nav-item active">
            <a class="nav-link" href="dashboard">
                <i class="fas fa-fw fa-table"></i>
                <span>Dashboard</span>
            </a>
        </li>

        <li class="nav-item active">
            <a class="nav-link" href="employees">
                <i class="fas fa-fw fa-table"></i>
                <span>Employee</span>
            </a>
        </li>

        <li class="nav-item active">
            <a class="nav-link" href="positions">
                <i class="fas fa-fw fa-table"></i>
                <span>Position</span>
            </a>
        </li>

        <li class="nav-item active">
            <a class="nav-link" href="employeePositions">
                <i class="fas fa-fw fa-table"></i>
                <span>Employee Position</span>
            </a>
        </li>
    </ul>
    <!-- ================= END SIDEBAR ================= -->



    <!-- ================= CONTENT WRAPPER ================= -->
    <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">

            <!-- ================= TOPBAR ================= -->
            <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 shadow">

                <button id="sidebarToggleTop"
                        class="btn btn-link d-md-none rounded-circle mr-3">
                    <i class="fa fa-bars"></i>
                </button>

                <ul class="navbar-nav ml-auto">
                    <li class="nav-item dropdown no-arrow">
                        <a class="nav-link dropdown-toggle"
                           href="#"
                           data-toggle="dropdown">
                            <span class="mr-2 d-none d-lg-inline text-gray-600 small">
                                Douglas McGee
                            </span>
                            <img class="img-profile rounded-circle"
                                 src="${pageContext.request.contextPath}/assets/img/undraw_profile.svg">
                        </a>
                    </li>
                </ul>

            </nav>
            <!-- ================= END TOPBAR ================= -->