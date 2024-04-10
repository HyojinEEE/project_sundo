<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>지도</title>
<link href="./css/menu.css?ver=0.19" rel="stylesheet">

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<script
   src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
   integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
   crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<!-- <script type="text/javascript" src="resource/js/ol.js"></script> OpenLayer 라이브러리
<link href="resource/css/ol.css" rel="stylesheet" type="text/css" > OpenLayer css -->
<script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css">
<script type="text/javascript">


	$("#tanso").on("click", function() {
		$("#uploaddiv").hide();
		$("#chartdiv").hide();

		let upload = document.querySelector('#data');
		let chart = document.querySelector('#statics');
		let select = document.querySelector('#tanso');

		upload.classList.remove('active');
		chart.classList.remove('active');
		select.classList.add('active');

		$("#selectdiv").show();
	})

	$("#data").on("click", function() {
		$("#selectdiv").hide();
		$("#chartdiv").hide();

		let upload = document.querySelector('#data');
		let chart = document.querySelector('#statics');
		let select = document.querySelector('#tanso');

		select.classList.remove('active');
		chart.classList.remove('active');
		upload.classList.add('active');

		$("#uploaddiv").show();
	})

	$("#statics").on("click", function() {
		$("#selectdiv").hide();
		$("#uploaddiv").hide();

		let upload = document.querySelector('#data');
		let chart = document.querySelector('#statics');
		let select = document.querySelector('#tanso');

		upload.classList.remove('active');
		select.classList.remove('active');

		chart.classList.add('active');

		$("#chartdiv").show();
	})

	
	
	
	$(function() {

		var sd, sgg, bjd;

		let Base = new ol.layer.Tile(
				{
					name : "Base",
					source : new ol.source.XYZ(
							{
								url : 'https://api.vworld.kr/req/wmts/1.0.0/5B43F370-69B3-368F-9B73-8B27D9708047/Base/{z}/{y}/{x}.png'
							})
				}); // WMTS API 사용

		let olview = new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
			center : ol.proj.transform([ 126.970371, 37.554376 ], 'EPSG:4326',
					'EPSG:3857'),
			zoom : 15
		});

		let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
			target : 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
			layers : [ Base ],// 지도에서 사용 할 레이어의 목록을 정희하는 공간이다
			view : olview
		});

		$("#sdselect").on(
				"change",
				function() { // id가 sdselect에 변화를 줬을때 함수를 실행해

					var test = $("#sdselect option:checked").text(); // text()로 실행하는 값 : ${sd.sd_nm} 을 test 변수에 넣어 

					$.ajax({
						url : "/selectSgg.do",
						type : "post",
						dataType : "json", // 받아오는 값
						data : {
							"test" : test
						}, //test 값을 "test"라는 이름으로 내보내
						success : function(result) { //성공했을때 실행하는 함수

							var geom = result.at(-1);
							map.getView().fit(
									[ geom.xmin, geom.ymin, geom.xmax,
											geom.ymax ], {
										duation : 900
									}); //줌 설정시, x와 y의 최대,최소값을 넣어준거임 duation 900은 보여지는 속도...?

							$("#sgg").empty(); // id가 sgg를 비워라
							var sgg = "<option>시군구 선택</option>";

							for (var i = 0; i < result.length - 1; i++) {
								sgg += "<option value='"+result[i].sgg_cd+"'>"
										+ result[i].sgg_nm + "</option>"
							}

							$("#sgg").append(sgg); //append가 sgg 아래에다가 추가/적용이 되는거
						},
						error : function() {
							alert("다시 시도하세요.");
						}
					})
				});

		$("#sgg").on("change", function() {
	    	  var sggzoom = $("#sgg option:checked").text();
	    	  alert(sggzoom);
	    	  $.ajax({
	              url : "/selectB.do",
	              type : "post",
	              dataType : "json",
	              data : {"sggzoom" : sggzoom}, 
	              success : function(result) {
	                  var bList = result.list;
	                  
	                  map.getView().fit([result.xmin, result.ymin, result.xmax, result.ymax], {duration : 900});                  
	               
	                  var sgg_CQL = "sgg_cd=" + $("#sgg").val();
	                  map.removeLayer(sgg);
	                  var sggSource = new ol.source.TileWMS({
	                     url : 'http://localhost:8080/geoserver/hyojin/wms?service=WMS',
	                     params : {
	                        'VERSION' : '1.1.0',
	                        'LAYERS' : 'hyojin:tl_sgg',
	                        'CQL_FILTER' : sgg_CQL,
	                        'BBOX' : [1.386872E7,3906626.5,1.4428071E7,4670269.5],
	                        'SRS' : 'EPSG:3857',
	                        'FORMAT' : 'image/png',
	                        'TRANSPARENT' : 'TRUE',
	                    },
	                    serverType : 'geoserver',
	                 });
	                 sgg = new ol.layer.Tile({
	                     source : sggSource,
	                     opacity : 0.5
	                  });
	                  map.addLayer(sgg);
	                  $("#legendSelect").val("default");
	                  legendSelected = false;
	              },
	              error : function() {
	                 alert("실패");
	              }
	           });
	        });
	      

		.


		$("#transmit").on("click", function() { //id가 transdb를 클릭했을때 실행하는 함수
			var test = $("#txtfile").val().split(".").pop();
			// id가 txtfile에서 .을 분리해서 txt가 추출되어 test 변수에 저장 된다.

			var formData = new FormData();
			formData.append("testfile", $("#txtfile")[0].files[0]);
			//testfile : 전송할 때 사용할 이름  / id가 txtfile인 선택된 첫번째 파일
			if ($.inArray(test, [ 'txt' ]) == -1) { //test 변수가 ['txt']안에 있는지 확인 있다면 1, 없다면 -1
				alert("pem 파일만 업로드 할 수 있습니다.");
				$("#txtfile").val("");
				return false;
			}

			$.ajax({
				url : "/fileUpload.do", // 파일을 업로드할 서버의 경로를 지정
				type : 'post',
				enctype : 'multipart/form-data',
				//contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
				data : formData,
				contentType : false,
				processData : false,
				beforeSend : function() {
					modal();
				},
				success : function() {
					$('#uploadtext').text("업로드 완료");
					setTimeout(timeout, 5000);
				}
			})
		})
	})
	var timeout = function() {
		$('#mask').remove();
		$('#loading').remove();
	}

	function modal() {

		var maskHeight = $(document).height();
		var maskWidth = window.document.body.clientWidth;

		var mask = "<div id='mask' style='position:absolute;z-indx:5;background-color: rgba(0, 0, 0, 0.13);display:none;left:0;top:0;'></div>";
		var loading = "<div id='loading' style='background-color:white;width:500px'><h1 id='uploadtext' style='text-align:center'>업로드 진행중</h1></div>";

		$('body').append(mask);
		$('#mask').append(loading);

		$("#mask").css({
			'height' : maskHeight,
			'width' : maskWidth
		});

		$('#loading').css({
			/* 'position': 'absolute',
			 'top': '50%',
			  'left': '50%',
			  'transform': 'translate(-50%, -50%)' */
			'position' : 'absolute',
			'left' : '800px',
			'top' : '100px'

		})
		$('#mask').show();
		$('#loading').show();
	}
</script>

<style type="text/css">
.map {
   width: 100%;
   height: 100vh;
   padding-left: 0;
}


</style>
</head>
<body>
    <div class="container mt-5">
        <div class="row">
         <%@ include file="menu.jsp" %>
            <div class="col-md-7">
                <div class="map" id="map">
                
                </div>
                
                
                
            </div>
            <div class="selectdiv col-md-4">
                <select class="form-select mb-3" id="sdselect">
                    <option>시도 선택</option>
                    <c:forEach items="${list }" var="sd">
                        <option class="sd" value="${sd.sd_cd }">${sd.sd_nm}</option>
                    </c:forEach>
                </select>
                <select class="form-select mb-3" id="sgg">
                    <option>시군구 선택</option>
                </select>
                <select id="legendSelect" class="form-select mb-3">
					<option value="default">범례 선택</option>
					<option value="1">등간격</option>
					<option value="2">네추럴 브레이크</option>
				</select>
                <button id="insertbtn" class="btn btn-primary mb-3">입력하기</button>
                <form id="uploadForm" class="mb-3">
                    <input type="file" class="form-control" accept=".txt" id="txtfile" name="txtfile">
                </form>
                <button id="transmit" class="btn btn-success">전송하기</button>
            </div> 
        </div>
    </div>
    
    
    
</body>
</html>
