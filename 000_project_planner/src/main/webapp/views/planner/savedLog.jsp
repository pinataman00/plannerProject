<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 플래너</title>
</head>

<style>

	#plannerHeader{
	
		width : 100vw;
		height : 20vh;
		background-color : blue;
	
	}
	#plannerTitle{
	
    margin-top: 0;
    padding-top: 46px;
    padding-left: 42px;
	
	}

	#placeMap{
	
	border: 1px solid red;
    width: 400px;
    height: 400px;
    margin-top: 129px;
    margin-left: 100px;
    margin-bottom : 100px;
	
	}
	
	#planOption{
	
    margin-top: 100px;
    margin-left: 84px;
    margin-bottom: 30px;
    width: 407px;
	
	}

</style>
<body>

	<div id="container">
		<div id="plannerHeader">
			<h1 id="plannerTitle">회원ID님의 플래너</h1>
			<br>
			<select id="planOption">
				<option>예시</option>
			</select>
			<div id="placeMap"></div>
		
		</div>
	</div>


</body>
</html>