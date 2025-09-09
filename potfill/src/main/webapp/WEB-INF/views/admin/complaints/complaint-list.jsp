<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 민원 관리</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>

    <h1>민원 관리 페이지</h1>

    <table>
        <thead>
            <tr>
                <th>민원 ID</th>
                <th>상태</th>
                <th>신고자</th>
                <th>주소</th>
                <th>위험도</th>
                <th>신고일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="complaint" items="${complaintList}">
                <tr>
                    <td>${complaint.complaintId}</td>
                    <td><c:out value="${complaint.status != null ? complaint.status : '접수'}"/></td>
                    <td>${complaint.reporterName}</td>
                    <td>${complaint.incidentAddress}</td>
                    <td>${complaint.riskLevel}</td>
                    <td>
                        <fmt:formatDate value="${complaint.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty complaintList}">
                <tr>
                    <td colspan="6">조회된 민원이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

</body>
</html>