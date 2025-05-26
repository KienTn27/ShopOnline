

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<!--
Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Html.html to edit this template
-->
<!DOCTYPE html>
<html lang="fr">
    <head>
        <!-- Site meta -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Free Bootstrap 4 Ecommerce Template</title>
        <!-- CSS -->
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" type="text/css">
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">
        <link href="//fonts.googleapis.com/css?family=Open+Sans:400,300,600" rel="stylesheet" type="text/css">
        <link href="css/style.css" rel="stylesheet" type="text/css">
    </head>
    <body>

        <nav class="navbar navbar-expand-md navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="homepage">Shop369</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExampleDefault" aria-controls="navbarsExampleDefault" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse justify-content-end" id="navbarsExampleDefault">
                    <ul class="navbar-nav m-auto">
                        <li class="nav-item active">
                            <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="category">Categories</a>
                        </li>
                        
                        <li class="nav-item">
                            <a class="nav-link" href="cart">Cart</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="contact">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="login.jsp">Đăng nhập</a>
                        </li>
                    </ul>

                    <form class="form-inline my-2 my-lg-0" action="search">
                        <div class="input-group input-group-sm">
                            <input type="text" class="form-control" placeholder="Search..." name="value">
                            <div class="input-group-append">
                                <button type="button" class="btn btn-secondary btn-number">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                        <a class="btn btn-success btn-sm ml-3" href="cart">
                            <i class="fa fa-shopping-cart"></i> Cart
                            
                        </a>
                    </form>
                </div>
            </div>
        </nav>

        <section class="jumbotron text-center">
            <div class="container">
                <h1 class="jumbotron-heading">Chào mừng ${user.fullName} đến với Shop369</h1>
                <p class="lead text-muted mb-0">
                    Khám phá những mẫu quần áo mới nhất với giá ưu đãi và dịch vụ chuyên nghiệp – chỉ có tại Shop369!
                </p>
            </div>
        </section>

        <div class="container">
            <div class="row">
                <div class="col">
                    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
                        <ol class="carousel-indicators">
                            <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
                            <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
                            <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
                        </ol>
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img class="d-block w-100" src="https://studiovietnam.com/wp-content/uploads/2022/12/mau-anh-chup-ao-thun-nam-21.jpg" alt="First slide">
                            </div>
                            <div class="carousel-item">
                                <img class="d-block w-100" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBOujbyRHttAnc43OEzyG7B_4qg74iE9AWjA&s" alt="Second slide">
                            </div>
                            <div class="carousel-item">
                                <img class="d-block w-100" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqkAaOb6W3hQdD5CAlnh9HJtpZ76sYHzi8nA&s" alt="Third slide">
                            </div>
                        </div>
                        <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="sr-only">Previous</span>
                        </a>
                        <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="sr-only">Next</span>
                        </a>
                    </div>
                </div>
                <div class="col-12 col-md-3">
                    <div class="card">
                        <div class="card-header bg-success text-white text-uppercase">
                            <i class="fa fa-heart"></i> Top product
                        </div>
                        <img class="img-fluid border-0" src="https://dummyimage.com/600x400/55595c/fff" alt="Card image cap">
                        <div class="card-body">
                            <h4 class="card-title text-center"><a href="product" title="View Product">Product title</a></h4>
                            <div class="row">
                                <div class="col">
                                    <p class="btn btn-danger btn-block">99.00 $</p>
                                </div>
                                <div class="col">
                                    <a href="product" class="btn btn-success btn-block">View</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div class="container mt-3">
            <div class="row">
                <div class="col-sm">
                    <div class="card">
                        <div class="card-header bg-primary text-white text-uppercase">
                            <i class="fa fa-star"></i> New products
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <c:if test="${empty requestScope.top}">
                                    <p>Không có dữ liệu sản phẩm nào!</p>
                                </c:if>
                                <c:forEach var="c" items="${requestScope.top}">
                                    <!-- Sử dụng các lớp Bootstrap để đảm bảo 4 cột trên màn hình lớn, 6 cột trên màn hình vừa -->
                                    <div class="col-12 col-md-2 col-lg-3 d-flex align-items-stretch">
                                        <div class="card w-100">
                                            <img class="card-img-top" src="${c.imageUrl}" alt="Card image cap">
                                            <div class="card-body d-flex flex-column">
                                                <h4 class="card-title">
                                                    <a href="product1?productId=${c.productId}" title="View Product">
                                                        ${c.name}
                                                    </a>
                                                </h4>
                                                <!-- Sử dụng flex-grow-1 để phần mô tả chiếm không gian còn lại -->
                                            <%--    <p class="card-text flex-grow-1">
                                                    ${c.description}
                                                </p>--%>
                                                <!-- Đẩy phần nút xuống dưới cùng -->
                                                <div class="mt-auto">
                                                    <div class="row">
                                                        <div class="col">
                                                            <a href="product1?productId=${c.productId}" class="btn btn-danger btn-block">
                                                                <fmt:formatNumber value="${c.price}" type="number" groupingUsed="true" /> đ
                                                            </a>
                                                        </div>
                                                                <%--  <div class="col">
                                                            <a href="cart" class="btn btn-success btn-block">Add to cart</a>
                                                        </div>--%>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <%--          <div class="col-sm">
                                              <div class="card">
                                                  <img class="card-img-top" src="https://dummyimage.com/600x400/55595c/fff" alt="Card image cap">
                                                  <div class="card-body">
                                                      <h4 class="card-title"><a href="product" title="View Product">Product title</a></h4>
                                                      <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                                      <div class="row">
                                                          <div class="col">
                                                              <p class="btn btn-danger btn-block">99.00 $</p>
                                                          </div>
                                                          <div class="col">
                                                              <a href="cart" class="btn btn-success btn-block">Add to cart</a>
                                                          </div>
                                                      </div>
                                                  </div>
                                              </div>
                                          </div>
                                          <div class="col-sm">
                                              <div class="card">
                                                  <img class="card-img-top" src="https://dummyimage.com/600x400/55595c/fff" alt="Card image cap">
                                                  <div class="card-body">
                                                      <h4 class="card-title"><a href="product" title="View Product">Product title</a></h4>
                                                      <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                                      <div class="row">
                                                          <div class="col">
                                                              <p class="btn btn-danger btn-block">99.00 $</p>
                                                          </div>
                                                          <div class="col">
                                                              <a href="cart" class="btn btn-success btn-block">Add to cart</a>
                                                          </div>
                                                      </div>
                                                  </div>
                                              </div>
                                          </div>
                                          <div class="col-sm">
                                              <div class="card">
                                                  <img class="card-img-top" src="https://dummyimage.com/600x400/55595c/fff" alt="Card image cap">
                                                  <div class="card-body">
                                                      <h4 class="card-title"><a href="product" title="View Product">Product title</a></h4>
                                                      <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                                      <div class="row">
                                                          <div class="col">
                                                              <p class="btn btn-danger btn-block">99.00 $</p>
                                                          </div>
                                                          <div class="col">
                                                              <a href="cart." class="btn btn-success btn-block">Add to cart</a>
                                                          </div>
                                                      </div>
                                                  </div>
                                              </div>
                                          </div>--%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div class="container mt-3 mb-4">
            <div class="row">
                <div class="col-sm">
                    <div class="card">
                        <div class="card-header bg-primary text-white text-uppercase">
                            <i class="fa fa-trophy"></i> Last products
                        </div>
                        <div class="card-body">

                            <div class="row">
                                <c:forEach var="c" items="${requestScope.top1}">
                                    <!-- Sử dụng "d-flex align-items-stretch" trên col để các card có chiều cao bằng nhau -->
                                    <div class="col-sm d-flex align-items-stretch">
                                        <div class="card w-100">
                                            <img class="card-img-top" src="${c.imageUrl}" alt="Card image cap">
                                            <!-- Sử dụng flex-column cho card-body để phần nội dung tự co giãn -->
                                            <div class="card-body d-flex flex-column">
                                                <h4 class="card-title">
                                                    <a href="product1?productId=${c.productId}" title="View Product">
                                                        ${c.name}
                                                    </a>
                                                </h4>
                                                <!-- Nếu có mô tả sản phẩm, thay thế placeholder bên dưới bằng ${c.description} -->
                                             <%--   <p class="card-text flex-grow-1">
                                                    ${c.description}
                                                </p> --%>
                                                <!-- mt-auto để đẩy phần nút xuống dưới cùng của card -->
                                                <div class="mt-auto">
                                                    <div class="row">
                                                        <div class="col">
                                                            <a href="product1?productId=${c.productId}" class="btn btn-danger btn-block">
                                                                <fmt:formatNumber value="${c.price}" type="number" groupingUsed="true" /> đ
                                                            </a>
                                                        </div>
                                                       
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <%--  <div class="col-sm">
                                      <div class="card">
                                          <img class="card-img-top" src="https://dummyimage.com/600x400/55595c/fff" alt="Card image cap">
                                          <div class="card-body">
                                              <h4 class="card-title"><a href="product" title="View Product">Product title</a></h4>
                                              <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                              <div class="row">
                                                  <div class="col">
                                                      <p class="btn btn-danger btn-block">99.00 $</p>
                                                  </div>
                                                  <div class="col">
                                                      <a href="cart" class="btn btn-success btn-block">Add to cart</a>
                                                  </div>
                                              </div>
                                          </div>
                                      </div>
                                  </div>
                                  <div class="col-sm">
                                      <div class="card">
                                          <img class="card-img-top" src="https://dummyimage.com/600x400/55595c/fff" alt="Card image cap">
                                          <div class="card-body">
                                              <h4 class="card-title"><a href="product" title="View Product">Product title</a></h4>
                                              <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                              <div class="row">
                                                  <div class="col">
                                                      <p class="btn btn-danger btn-block">99.00 $</p>
                                                  </div>
                                                  <div class="col">
                                                      <a href="cart" class="btn btn-success btn-block">Add to cart</a>
                                                  </div>
                                              </div>
                                          </div>
                                      </div>
                                  </div>
                                  <div class="col-sm">
                                      <div class="card">
                                          <img class="card-img-top" src="https://dummyimage.com/600x400/55595c/fff" alt="Card image cap">
                                          <div class="card-body">
                                              <h4 class="card-title"><a href="product" title="View Product">Product title</a></h4>
                                              <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                              <div class="row">
                                                  <div class="col">
                                                      <p class="btn btn-danger btn-block">99.00 $</p>
                                                  </div>
                                                  <div class="col">
                                                      <a href="cart" class="btn btn-success btn-block">Add to cart</a>
                                                  </div>
                                              </div>
                                          </div>
                                      </div>
                                  </div>--%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- Footer -->
        <footer class="text-light">
            <div class="container">
                <div class="row">
                    <div class="col-md-3 col-lg-4 col-xl-3">
                        <h5>About</h5>
                        <hr class="bg-white mb-2 mt-0 d-inline-block mx-auto w-25">
                        <p class="mb-0">
                            Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression.
                        </p>
                    </div>

                    <div class="col-md-2 col-lg-2 col-xl-2 mx-auto">
                        <h5>Informations</h5>
                        <hr class="bg-white mb-2 mt-0 d-inline-block mx-auto w-25">
                        <ul class="list-unstyled">
                            <li><a href="">Link 1</a></li>
                            <li><a href="">Link 2</a></li>
                            <li><a href="">Link 3</a></li>
                            <li><a href="">Link 4</a></li>
                        </ul>
                    </div>

                    <div class="col-md-3 col-lg-2 col-xl-2 mx-auto">
                        <h5>Others links</h5>
                        <hr class="bg-white mb-2 mt-0 d-inline-block mx-auto w-25">
                        <ul class="list-unstyled">
                            <li><a href="">Link 1</a></li>
                            <li><a href="">Link 2</a></li>
                            <li><a href="">Link 3</a></li>
                            <li><a href="">Link 4</a></li>
                        </ul>
                    </div>

                    <div class="col-md-4 col-lg-3 col-xl-3">
                        <h5>Contact</h5>
                        <hr class="bg-white mb-2 mt-0 d-inline-block mx-auto w-25">
                        <ul class="list-unstyled">
                            <li><i class="fa fa-home mr-2"></i> My company</li>
                            <li><i class="fa fa-envelope mr-2"></i> email@example.com</li>
                            <li><i class="fa fa-phone mr-2"></i> + 33 12 14 15 16</li>
                            <li><i class="fa fa-print mr-2"></i> + 33 12 14 15 16</li>
                        </ul>
                    </div>
                    <div class="col-12 copyright mt-3">
                        <p class="float-left">
                            <a href="#">Back to top</a>
                        </p>
                        <p class="text-right text-muted">created with <i class="fa fa-heart"></i> by <a href="https://t-php.fr/43-theme-ecommerce-bootstrap-4.html"><i>t-php</i></a> | <span>v. 1.0</span></p>
                    </div>
                </div>
            </div>
        </footer>

        <!-- JS -->
        <script src="//code.jquery.com/jquery-3.2.1.slim.min.js" type="text/javascript"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" type="text/javascript"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" type="text/javascript"></script>

    </body>
</html>


