package com.blogjsp.dao;

import com.blogjsp.entities.User;
import com.blogjsp.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDao {

    public static String saveUser(User user){

        Connection con = DbConnection.connect();

        if( con != null ){

            if(findUser(user.getUserEmail()))
                return "Email já cadastrado";

            String query = "insert into users(userEmail, userPassword, isAdmin) values (?, ?, ?)";

            try {
                PreparedStatement stm = con.prepareStatement(query);
                stm.setString(1, user.getUserEmail());
                stm.setString(2, user.getUserPassword());
                stm.setBoolean(3, false);

                stm.execute();
            } catch (SQLException e) {
                return "Erro ao realizar cadastro: "+e.getMessage();
            }
            return "Usuário cadastrado com sucesso";
        }
            return "Falha ao conectar ao banco de dados";
    }

    public static boolean findUser(String userEmail){
        Connection con = DbConnection.connect();

        if( con != null ){

            String query = "select userEmail from users where userEmail = ?";

            try {
                PreparedStatement stm = con.prepareStatement(query);
                stm.setString(1, userEmail);

                ResultSet result = stm.executeQuery();
                if(result.next()){
                    return true;
                }
                return false;
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
        return false;
    }

    public static User login(User user){

        Connection con = DbConnection.connect();
        User lUser = null;

        if( con != null ){
            String query = "select * from users where userEmail = ? and userPassword = ?";

            try {
                PreparedStatement stm = con.prepareStatement(query);
                stm.setString(1, user.getUserEmail());
                stm.setString(2, user.getUserPassword());

                ResultSet rs = stm.executeQuery();

                if(rs.next()){
                    lUser = new User();
                    lUser.setId(rs.getInt("id"));
                    lUser.setUserEmail(rs.getString("userEmail"));
                    lUser.setAdmin(rs.getBoolean("isAdmin"));
                }

            } catch (SQLException e) {
                //TODO: tratar erro
                throw new RuntimeException(e);
            }
        }
        return lUser;
    }
    public static User findUserById(int userId){

        Connection con = DbConnection.connect();
        User u = new User();
        if( con != null ){

            String query = "select * from users where id = ?";

            try {
                PreparedStatement stm = con.prepareStatement(query);
                stm.setInt(1, userId);

                ResultSet rs = stm.executeQuery();
                if(rs.next()){
                    u.setId(rs.getInt("id"));
                    u.setUserEmail(rs.getString("userEmail"));
                    u.setAdmin(rs.getBoolean("isAdmin"));
                }

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
        return u;
    }
    public static String findUserNameById(int userId){

        Connection con = DbConnection.connect();

        if( con != null ){

            String query = "select userEmail from users where id = ?";

            try {
                PreparedStatement stm = con.prepareStatement(query);
                stm.setInt(1, userId);

                ResultSet rs = stm.executeQuery();
                if(rs.next()){
                    return rs.getString("userEmail");
                }

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
        return "Usuário não encontrado";
    }
}
