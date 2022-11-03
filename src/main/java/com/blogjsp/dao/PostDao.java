package com.blogjsp.dao;

import com.blogjsp.entities.Post;
import com.blogjsp.entities.User;
import com.blogjsp.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PostDao {

    public static String savePost(Post post){

        Connection con = DbConnection.connect();

        if( con != null){
            User user = UserDao.findUserById(post.getUserId());
            if(!user.isAdmin()){
                return "Usuário não possui permissões para postar.";
            }
            try {
                String query = "insert into posts (title, body, createdAt, userId) values (?, ?, now(), ?)";
                PreparedStatement stm = con.prepareStatement(query);

                stm.setString(1, post.getTitle());
                stm.setString(2, post.getBody());
                stm.setInt(3, post.getUserId());

                stm.execute();
                return "Postado com sucesso.";
            } catch (SQLException e) {
                return "Erro ao enviar postar: "+e.getMessage()+
                        ". Tente novamente mais tarde.";
            }
        }
        return "Falha no servidor. Aguarde alguns instantes e tente novamente.";
    }

    public static List<Post> getPostList(int page, int nPosts){

        Connection con = DbConnection.connect();
        List<Post> postList = new ArrayList<Post>();
        if(con != null){

            String query = "select * from posts order by createdAt desc limit ?, ?";
            int pg = page - 1;
            pg = pg < 0 ? 0 : pg;
            try {
                PreparedStatement stm = con.prepareStatement(query);

                stm.setInt(1, pg * nPosts);
                stm.setInt(2, nPosts);
                ResultSet rs = stm.executeQuery();
                while (rs.next()){
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setUserId(rs.getInt("userId"));
                    post.setTitle(rs.getString("title"));
                    post.setBody(rs.getString("body"));
                    post.setCreatedAt(rs.getTimestamp("createdAt"));
                    postList.add(post);
                }
            } catch (SQLException e) {
                return postList;
            }

        }
            return postList;
    }

    public static String updatePost(Post editedPost){

        Connection con = DbConnection.connect();

        if( con != null){
            try {
                String query = "update posts set title = ?, body = ? where id = ?";
                PreparedStatement stm = con.prepareStatement(query);

                stm.setString(1, editedPost.getTitle());
                stm.setString(2, editedPost.getBody());
                stm.setInt(3, editedPost.getId());

                int upd = stm.executeUpdate();
                if(upd > 0)
                    return "Atualizado com sucesso!";

            } catch (SQLException e) {
                return "Erro ao Atualizar: "+e.getMessage();
            }
        }
        return "Ops! Ocorreu um erro. Tente novamente";
    }

    public static String deletePost(int postId){

        Connection con = DbConnection.connect();
        System.out.println(postId);
        if( con != null){
            try {
                String query = "delete from posts where id = ?";
                PreparedStatement stm = con.prepareStatement(query);

                stm.setInt(1, postId);

                int upd = stm.executeUpdate();
                System.out.println("Post deletado com sucesso!");
                if(upd > 0)
                    return "Post deletado com sucesso!";

            } catch (SQLException e) {
                return "Erro ao deletar: "+e.getMessage();
            }
        }
        return "Ops! Ocorreu um erro. Tente novamente";
    }

    public static Post getOnePost(int id){

        Connection con = DbConnection.connect();
        Post post = null;
        if(con != null){

            String query = "select * from posts where id = ?";

            try {
                PreparedStatement stm = con.prepareStatement(query);

                stm.setInt(1, id);

                ResultSet rs = stm.executeQuery();
                while (rs.next()){
                    post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setUserId(rs.getInt("userId"));
                    post.setTitle(rs.getString("title"));
                    post.setBody(rs.getString("body"));
                    post.setCreatedAt(rs.getTimestamp("createdAt"));

                    post.setCommentList(CommentDao.getCommentList(post.getId()));
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

        }
        return post;
    }

    public static int getPostCount(){

        Connection con = DbConnection.connect();
        int nPosts = 0;
        if(con != null){

            String query = "select count(*) as postCount from posts";
            try {
                PreparedStatement stm = con.prepareStatement(query);

                ResultSet rs = stm.executeQuery();
                if (rs.next()){
                    nPosts = rs.getInt("postCount");
                    System.out.println(nPosts);
                }
            } catch (SQLException e) {
                return nPosts;
            }
        }
        return nPosts;
    }
}
