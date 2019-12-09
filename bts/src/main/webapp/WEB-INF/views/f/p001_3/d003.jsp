<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"
    isELIgnored="false"
    %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="tourKey"><spring:eval expression="@file.getProperty('tour.key')" /></c:set>
<c:set var="apiUrl"><spring:eval expression="@file.getProperty('tour.detailCommon')" /></c:set>
<c:set var="insertUrl"  value="${pageContext.request.contextPath}/community/review/write" />   
<c:set var="uploadUrl"  value="${pageContext.request.contextPath}/community/review/write/mod" />   
<!DOCTYPE html>
<html>
<head>
<style>
   @font-face{
      src:url("/bts/resources/fonts/Nanum/NanumSquareRoundR.ttf");
      font-family:"nanum";   
   }
   
      @font-face{
      src:url("../fonts/BMJUA_ttf.ttf");
      font-family:"bm";   
   }
   
   #cke_editor{
      margin:0 auto;
   }
   
   
   #title{
      text-align:center;
      margin:20px 0 10px 20px;
      font-size:50px;
   }
   
   #title>input{
      padding:0 10px;
      width:80%;
      border:none;
      border-bottom:2px solid #9c9c9c;
      font-size:45px;
      font-family:"nanum"   
   }
   #title>input::placeholder,#tag-list>input[type=text]::placeholder{
      font-style:oblique;
      color:#a8a8a8;
      font-family:initial;
   }
   
   #tag-list{
      width:80%;
      margin:0 auto;
      margin-top:10px;
   }
   
   #review-type{
      width:80%;
      margin:10px auto;
   }
   
   #review-type>div:first-child{
      margin-left:15px;
   }
   
   #tag-list>input[type=text]{
      margin-left:20px;
      padding:0 10px;
      border:none;
      border-bottom:1px solid #9c9c9c;
   }
   
   .tag-result{
      border :1px solid;
      border-radius : 10px;
      padding : 5px;
      text-align:center;
      margin-left:5px;
   }
   .tag-result span{
      margin-left:0 3px;
   }
   
   #tag-list a{
      margin-left : 3px;
      color:red;
      cursor: pointer;
   }
   
   #end,#endMod{
      margin-top:30px;
      margin-right:11%;
      width:150px;
   }
   
   table.table{
	  margin-top:10px;
	  font-family:"nanum";
   }
   
</style>
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<script src="${contextPath}/resources/library/ckeditor4/ckeditor.js"></script>
<script>
   $(document).ready(function(){
      $('#review-type>input:button').attr('disabled',true);
      CKEDITOR.replace('editor',{
         width:'80%',
         height:500,
         filebrowserUploadUrl : "${contextPath}/community/review/image"
      });
      
      CKEDITOR.on('dialogDefinition',function(ev){
         var dialogName=ev.data.name;
         var dialog = ev.data.definition.dialog;
         var dialogDefiniton = ev.data.definition;
         
         if(dialogName=="image"){
            dialog.on('show',function(obj){
               this.selectPage("Upload");
            });
            dialogDefiniton.removeContents('advanced');
            dialogDefiniton.removeContents('Link');
            
            var infoTab = dialogDefiniton.getContents('info');
            console.log(infoTab);
            infoTab.remove('txtAlt');
              infoTab.remove( 'txtHSpace'); //info 탭 내에 불필요한 엘레멘트들 제거
              infoTab.remove( 'txtVSpace');
              infoTab.remove( 'txtBorder');

         }
      });
      
      $('#end').on('click',function(){
         var frm = submitAction();
         frm.action="${contextPath}/community/review/upload";
         frm.submit();
      })
      
      $('#endMod').on('click',function(){
         var frm = submitAction();
         frm.action="${contextPath}/community/review/upload/mod";
         frm.submit();
      })
      
      $('#tag-list>input[type=text]').on("keydown",function(event){
         if(event.keyCode==13){
            var inputText = $(this).val();
            if(inputText.trim()==''){
               alert('태그를 입력해주세요');
               return;
            };
            addTag(inputText);
            $(this).val('');
         }
      });
      
      $("input:radio[name=test]").click(function(){
         if($(this).prop('value')=='test2'){
            $('#review-type>input:button').attr('disabled',false);
            $('#review-type>input:button').removeClass('disabled');
         }else{
            $('#review-type>input:button').attr('disabled',true);            
            $('#review-type>input:button').addClass('disabled');
         }
      });

      $('a[href="#recommend"]').on("show.bs.tab",function(){
    	  modalPaging($('ul[data-paging="recommend"]'),1);
      });

      $('a[href="#plan"]').on("show.bs.tab",function(){
    	  modalPaging($('ul[data-paging="plan"]'),1);
        });
      
      $(document).on('click','a.page-link',function(){
          modalPaging($(this).parent().parent(),$(this).text());
       });      
      
      function submitAction(){
         var test = document.createElement('div');
         var contents = CKEDITOR.instances.editor.getData();
         test.innerHTML = contents;
         var img = $(test).find('img').toArray();
         var result = new Array();
         
         for(var i in img){
            result.push($(img[i]).attr('src'));
         }
         
         //tag
         var inputTag = $('.tag-input').toArray();
         var tagResult = new Array();
         for(var j in inputTag){
            tagResult.push($(inputTag[j]).text());
         }
         
         var frm = document.frmWrite;
         frm.imageList.value=JSON.stringify(result);
         frm.tagList.value=JSON.stringify(tagResult);
         return frm;
      }
      
      function isTagExist(inputText){
         var inputTag = $('.tag-input').toArray();
         for(var j in inputTag){
            if($(inputTag[j]).text()==inputText){
               return true;
            }
         }
         return false;
      }
      
      function addTag(/*String*/inputText){
         if(!isTagExist(inputText)){            
            var result=document.createElement('span');
            var sharp=document.createElement('span');
            var input=document.createElement('span');
            var a=document.createElement('a');
            
            result.append(sharp);
            result.append(input);
            result.append(a);
            
            $(result).addClass('tag-result');
            $(input).addClass('tag-input');
            $(sharp).text('#');
            $(input).text(inputText)
            $(a).text('x');
            
            $('#tag-list>span').append(result);
         }else{
            alert('이미 존재하는 태그입니다.');
         }
      }
      
      function modalPaging(ul,paging){
    	   var startPage=ul.children().first().next().text();
    	   var endPage=ul.children().last().prev().text();
    	   var url='/community/review/my';
    	   if(ul.data('paging')=='recommend'){
    		   url+='/recommend'
    	   }else{
    		   url+='/plan'    		   
    	   }

       	   if(paging==ul.children().first().text()){
    		   paging=startPage-1;
    	   }else if(paging==ul.children().last().text()){
    		   paging=Number(endPage)+1;
    	   }

    	   var searchData={
    	         curPage : paging
    	   }

    	   $.ajax({
    	      type : "post", 
    	      async : false,
    	      url : "${contextPath}"+url,
    	      data: searchData,
    	      dataType:'json',
    	      success : function (data,textStatus){
    	    	  console.log(data);
    	    	  if(ul.data('paging')=='recommend'){
    	    		  parseRecommend(data.result);
    	    	  }else if(ul.data('paging')=='plan'){
    	    		  parsePlan(data.result);  
    	    	  }
    	    	  makePaging(ul,data.paging.startPage,data.paging.endPage,data.paging.curPage);
    	      },//end success
    	      error : function (data,textStatus){
    	         alert("에러가 발생했습니다.");
    	      }
    	   }); //end ajax   

    	}
      
      	function parseRecommend(result){
      		var reqUrl = "${apiUrl}?ServiceKey=${tourKey}&MobileOS=ETC&MobileApp=TourAPI3.0_Guide&defaultYN=Y&contentId=";
			$('#recommend tbody').empty();
      		for(var i in result){
      			var id=result[i].content_id;
      			$.ajax({
      				async : false,
      				url : reqUrl+id,
      				dataType : 'json',
     				success : function(data, textStatus) {
						var tr = document.createElement('tr');
						var th = document.createElement('th');
						var td = document.createElement('td');
						$(tr).data('contentId',id);
						$(tr).data('contenttypeid',data.response.body.items.item.contenttypeid);
						$(th).attr('scope','row');
						$(th).text(result[i].rnum);
						$(td).text(data.response.body.items.item.title);
						tr.append(th,td);
						$('#recommend tbody').append(tr);
     				},
     	            error : function(data, textStatus) {
     	               alert("잘못된 접근입니다.")
     	            }
      			});
      		}  		
      	}

      	function parsePlan(result){
      		$('#plan tbody').empty();
      	}      	
      	
		function makePaging(target,startPage,endPage,curPage){
			$(target).empty();
			
			for(var j=startPage-1;j<=endPage+1;j++){
			   var li=document.createElement('li');
			   var a=document.createElement('a');
			   $(li).addClass('page-item');
			   if(j==curPage){
			      $(li).addClass('active');
			   }
			   $(a).addClass('page-link');
			   if(j==startPage-1){
			      $(a).text('Previous');               
			   }else if(j==endPage+1){
			      $(a).text('Next');                              
			   }else{
			      $(a).text(j);               
			   }
			   li.append(a);
			   
			   $(target).append(li);
			}
		}			   
   })
</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form name="frmWrite" method="post">
		<div id="title">
			<input type="text" name="title" placeholder="제목" value="${contentsMod.title}">
		</div>
		<div id="review-type">
			<div class="custom-control custom-radio custom-control-inline">
				<input type="radio" id="test1" name="test" value="test1" class="custom-control-input">
				<label class="custom-control-label" for="test1">나만의 후기</label>
			</div>
			<div class="custom-control custom-radio custom-control-inline">
				<input type="radio" id="test2" name="test" value="test2" class="custom-control-input">
				<label class="custom-control-label" for="test2">사이트 후기</label>
			</div>
			<input type="button" class="btn btn-sm btn-outline-primary disabled" data-toggle="modal" data-target="#exampleModal" value="가져오기">
		</div>
		<textarea id="editor" name="editor">${contentsMod.contents}</textarea>
		<input type="hidden" name="imageList">
		<input type="hidden" name="tagList">
		<input type="hidden" name="article_no" value="${contentsMod.article_no}">
	</form>
	<div id="tag-list">
		<input type="text" placeholder="태그">
		<span>
			<c:forEach var="tags" items="${contentsMod.tag_list}">
				<span class="tag-result">
					<span>#</span>
					<span class="tag-input">${tags}</span>
					<a>x</a>
				</span>
			</c:forEach>
		</span>
	</div>
	<div class="row justify-content-md-end">
		<c:if test="${uri==insertUrl}">
			<input type="button" id="end" class="btn btn-outline-secondary" value="작성하기">
		</c:if>
		<c:if test="${uri==uploadUrl}">
			<input type="button" id="endMod" class="btn btn-outline-secondary" value="수정하기">
		</c:if>
	</div>
	<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">후기 대상 선택</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<ul class="nav nav-tabs">
						<li class="nav-item">
							<a class="nav-link" data-toggle="tab" href="#plan" role="tab">내 플랜</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" data-toggle="tab" href="#recommend" role="tab">내 위시리스트</a>
						</li>
					</ul>
					<div class="tab-content" id="myTabContent">
						<div class="tab-pane fade" id="plan" role="tabpanel">
							<table class="table table-sm table-hover">
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">제목</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th scope="row">1</th>
										<td>Markㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱ</td>
									</tr>
									<tr>
										<th scope="row">2</th>
										<td>Jacobㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱ</td>
									</tr>
									<tr>
										<th scope="row">3</th>
										<td>Larryㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱㄱ</td>
									</tr>
								</tbody>
							</table>
							<div>
								<ul data-paging="plan" class="pagination justify-content-center pagination-sm"></ul>
							</div>
						</div>
						<div class="tab-pane fade" id="recommend" role="tabpanel">
							<table class="table table-sm table-hover">
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">제목</th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
							<div>
								<ul data-paging="recommend" class="pagination justify-content-center pagination-sm"></ul>
							</div>
						</div>                  
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn btn-outline-secondary" data-dismiss="modal">Close</button>
					<button type="button" id="modal-save" class="btn btn-outline-primary">Save changes</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>