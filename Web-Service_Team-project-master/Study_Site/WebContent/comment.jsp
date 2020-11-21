<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>     

<html>
<head>
<title>Database SQL</title>
</head>
<body>

	<%@ include file="dbconn_web.jsp" %>				
	<table width="900" border="1">
		<tr>
			<th>게시물 아이디</th>
			<th>제목</th>
			<th>내용</th>
			<th>작성시간</th>
			<th>업데이트시간</th>
			<th>작성자 아이디</th>
		</tr>
		<%
			ResultSet rs = null;			
			PreparedStatement pstmt = null;

			try {
				String sql = "select * from post";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					int id = Integer.parseInt(rs.getString("id"));
					String title = rs.getString("title");
					String content = rs.getString("content");
					java.util.Date createdDate = rs.getDate("createdDate");
					java.util.Date updatedDate = rs.getDate("updatedDate");
					int user_id = Integer.parseInt(rs.getString("UserId"));
		%>
		<tr>
			<td><%=id%></td>
			<td><%=title%></td>
			<td><%=content%></td>
			<td><%=createdDate%></td>
			<td><%=updatedDate%></td>
			<td><%=user_id%></td>
		</tr>
		<%
				}
			} catch (SQLException ex) {
				out.println("Member 테이블 호출이 실패했습니다.<br>");
				out.println("SQLException: " + ex.getMessage());
			} finally {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			}
		%>
	</table>
	
	<form method="post" action="comment_process.jsp">
		<p>댓글달 게시글 선택 : <input type="text" name="post_id">
		<p>댓글 입력 : <input type="text" name="comment">
		<p><input type="submit" value="전송">
	</form>
</body>
</html>