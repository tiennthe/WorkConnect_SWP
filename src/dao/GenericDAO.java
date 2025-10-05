package dao;

import java.util.ArrayList;
import java.util.Collection;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public abstract class GenericDAO<T> extends DBContext {
    protected PreparedStatement statement;
    protected ResultSet resultSet;
    protected Map<String, Object> parameterMap;
    // Các constant đại diện cho giá trị true và false trong việc sử dụng OR và AND
    public static final boolean CONDITION_AND = true;
    public static final boolean CONDITION_OR = false;

    /**
     * Hàm này sử dụng để get dữ liệu từ database lên dựa trên tên bảng mà bạn
     * mong muốn.Hàm sẽ mặc định trả về một List có thể có giá trị hoặc List
     * rỗng
     *
     * @param clazz: tên bảng bạn muốn get dữ liệu về
     * @return list
     */
    protected List<T> queryGenericDAO(Class<T> clazz) {
        List<T> result = new ArrayList<>();
        try {
            // Lấy kết nối
            connection = new DBContext().connection;

            // Tạo câu lệnh SELECT
            StringBuilder sqlBuilder = new StringBuilder();
            sqlBuilder.append("SELECT * FROM ").append(clazz.getSimpleName());

            // Chuẩn bị câu lệnh
            statement = connection.prepareStatement(sqlBuilder.toString());
            // Thực thi truy vấn
            resultSet = statement.executeQuery();

            // Khai báo danh sách kết quả
            // Duyệt result set   
            while (resultSet.next()) {
                // Gọi hàm mapRow để map đối tượng
                T obj = mapRow(resultSet, clazz);

                // Thêm vào danh sách kết quả
                result.add(obj);
            }

            return result;
        } catch (IllegalAccessException
                | IllegalArgumentException
                | InstantiationException
                | NoSuchMethodException
                | InvocationTargetException
                | SQLException e) {
            System.err.println("4USER: Bắn Exception ở hàm query: " + e.getMessage());
        } finally {
            try {
                // Đóng kết nối và các tài nguyên
                if (resultSet != null) {

                }
                if (statement != null) {
                    statement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (Exception e) {
                System.err.println("4USER: Bắn Exception ở hàm query: " + e.getMessage());
            }
        }
        return result;
    }

    private static <T> T mapRow(ResultSet rs, Class<T> clazz) throws
            SQLException,
            NoSuchMethodException,
            InstantiationException,
            IllegalArgumentException,
            IllegalAccessException,
            InvocationTargetException {

        // Initialize the object of type T
        T obj = clazz.getDeclaredConstructor().newInstance();

        // Get metadata for checking column existence
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();

        // Get all fields of the class
        Field[] fields = clazz.getDeclaredFields();

        // Loop through each field
        for (Field field : fields) {
            field.setAccessible(true); // Make field accessible
            String fieldName = field.getName();

            // Check if the field exists in ResultSet columns
            boolean columnExists = false;
            for (int i = 1; i <= columnCount; i++) {
                if (metaData.getColumnName(i).equalsIgnoreCase(fieldName)) {
                    columnExists = true;
                    break;
                }
            }

            // If column does not exist in ResultSet, skip this field
            if (!columnExists) {
                continue;
            }

            // Get the value from the ResultSet for the current field
            Object value = getFieldValue(rs, field);

            // Check if the field type is LocalDateTime and convert if necessary
            if (field.getType().equals(LocalDateTime.class) && value instanceof Timestamp) {
                value = ((Timestamp) value).toLocalDateTime(); // Convert Timestamp to LocalDateTime
            }

            // Set the value to the field in the object
            field.set(obj, value);
        }

        return obj;
    }

    /**
     * Hàm lấy giá trị cho field từ result set
     *
     * @param rs
     * @param field
     * @return
     * @throws SQLException
     */
    private static Object getFieldValue(ResultSet rs, Field field) throws SQLException {

        Class<?> fieldType = field.getType();
        String fieldName = field.getName();

        if (Collection.class.isAssignableFrom(fieldType)) {
            return null;
        } else if (Map.class.isAssignableFrom(fieldType)) {
            return null;
        }

        // Kiểm tra kiểu dữ liệu và convert sang đúng kiểu
        if (fieldType == String.class) {
            return rs.getString(fieldName);
        } else if (fieldType == int.class || fieldType == Integer.class) {
            return rs.getInt(fieldName);
        } else if (fieldType == long.class || fieldType == Long.class) {
            return rs.getLong(fieldName);
        } else if (fieldType == double.class || fieldType == Double.class) {
            return rs.getDouble(fieldName);
        } else if (fieldType == boolean.class || fieldType == Boolean.class) {
            return rs.getBoolean(fieldName);
        } else if (fieldType == float.class || fieldType == Float.class) {
            return rs.getFloat(fieldName);
        } else if (fieldType == Date.class || fieldType == Date.class) {
            return rs.getDate(fieldName);
        } else if (fieldType == Character.class || fieldType == char.class) {
            return rs.getString(fieldName);
        } else if (fieldType == Character.class || fieldType == char.class) {
            String s = rs.getString(fieldName);
            return s.charAt(0);
        } else {
            return rs.getObject(fieldName);
        }
    }
}