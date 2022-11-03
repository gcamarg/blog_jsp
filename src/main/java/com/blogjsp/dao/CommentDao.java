package com.blogjsp.dao;

import com.blogjsp.entities.Comment;
import com.blogjsp.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommentDao {

    public static String saveComment(Comment comment){

        Connection con = DbConnection.connect();

        if( con != null){
            try {
                String query = "insert into comments (body, createdAt, userId, postId, approved) values (?, now(), ?, ?, false)";
                PreparedStatement stm = con.prepareStatement(query);

                stm.setString(1, comment.getBody());
                stm.setInt(2, comment.getUserId());
                stm.setInt(3, comment.getPostId());

                stm.execute();
                return "Obrigado pelo comentário! Aguarde aprovação da moderação.";
            } catch (SQLException e) {
                return "Erro ao enviar comentário: "+e.getMessage()+
                        ". Tente novamente mais tarde.";
            }
        }
        return "Falha no servidor. Aguarde alguns instantes e tente novamente.";
    }

    public static String approveComment(int commentId){

        Connection con = DbConnection.connect();

        if( con != null){
            try {
                String query = "update comments set approved = true where id = ?";
                PreparedStatement stm = con.prepareStatement(query);

                stm.setInt(1, commentId);

                stm.execute();
                return "Comentário aprovado pela moderação.";
            } catch (SQLException e) {
                return "Erro ao aprovar comentário: "+e.getMessage();
            }
        }
        return "Falha no servidor. Aguarde alguns instantes e tente novamente.";
    }

    public static String deleteComment(int commentId){

        Connection con = DbConnection.connect();

        if( con != null){
            try {
                String query = "delete from comments where id = ?";
                PreparedStatement stm = con.prepareStatement(query);

                stm.setInt(1, commentId);

                stm.execute();
                return "Comentário deletado pela moderação.";
            } catch (SQLException e) {
                return "Erro ao deletar comentário: "+e.getMessage();
            }
        }
        return "Falha no servidor. Aguarde alguns instantes e tente novamente.";
    }

    public static List<Comment> getCommentList(int postId){

        Connection con = DbConnection.connect();
        List<Comment> commentList = new ArrayList<Comment>();

        if(con != null){

            String query = "select * from comments where postId = ? order by createdAt asc";
            try {
                PreparedStatement stm = con.prepareStatement(query);

                stm.setInt(1, postId);
                ResultSet rs = stm.executeQuery();
                while (rs.next()){
                    Comment comment = new Comment();
                    comment.setId(rs.getInt("id"));
                    comment.setBody(rs.getString("body"));
                    comment.setCreatedAt(rs.getTimestamp("createdAt"));
                    comment.setUserId(rs.getInt("userId"));
                    comment.setPostId(rs.getInt("postId"));
                    comment.setApproved(rs.getBoolean("approved"));
                    comment.setUserEmail(UserDao.findUserNameById(comment.getUserId()));
                    commentList.add(comment);
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

        }
        return commentList;
    }

}
