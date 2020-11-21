<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>

<html>
<head>
    <title>comment processing</title>
</head>
<%
java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String today = formatter.format(new java.util.Date());

java.sql.Timestamp t = java.sql.Timestamp.valueOf(today);

%>
<body>
<!-- 댓글 업로드 기능-->
<!-- 댓글 달 게시물 선택하면 해당 게시물을 쓴 사용자의 아이디를 저장.. -->
<!-- 게시물 댓글, 아이디, 게시물 소유자 아이디, 만든시간, 업데이트 시간을  comment 테이블에 삽입 -->
<!-- 테이블 애트리 순서는 만든시간, 업데이트 시간, 댓글 달 게시물 아이디 , 해당 게시물 사용자 아이디, 댓글-->
<!-- Date, Date, int, int, string -->
	<%@ include file="dbconn_web.jsp" %>
	
	
	<%
		request.setCharacterEncoding("utf-8");
	
		String userPick = request.getParameter("post_id"); // 댓글을 달기위해 게시판 고유 번호를 전달받음 
		String userComment = request.getParameter("comment");
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			String sql = "select id, UserId from post where id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userPick);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				String rId = rs.getString("id"); // 게시판 고유 아이디 
				String rUserId = rs.getString("UserId"); // 게시물 작성자 아이디 
				
				if(userPick.equals(rId)){
					sql = "insert into comment(id, commentCol, createdDate, updatedDate, PostId, PostUserId) values(?, ?, ?, ?, ?, ?)";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, Integer.parseInt(rId)+1);// 댓글 고유 번호..
					pstmt.setString(2, userComment); // 유저 댓글 
					pstmt.setTimestamp(3, t); // 댓글 단 시간 
					pstmt.setTimestamp(4, t); // 시스템 현재 시간 받아오는 함수 사용할 것 
					pstmt.setString(5, rId);// 댓글 달 게시물 고유번호 
					pstmt.setString(6, rUserId); // 해당 게시물 올린 소유자 
					pstmt.executeUpdate();
					out.println("comment 테이블 삽입 성공");
				}
				else{
					out.println("일치하는 소유자가 없습니다.");
				}
			}
		}catch(SQLException ex){
			out.println("comment 테이블 삽입 실패");
			out.println("SQLException : " + ex.getMessage());
		}finally{
			if(pstmt != null)
				pstmt.close();
			if(conn != null)
				conn.close();
		}
		
		
	%>
</body>
</html>