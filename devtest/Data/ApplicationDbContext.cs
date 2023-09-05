using System.Data;
using System.Data.SqlClient;

namespace devtest.Data
{
    public class ApplicationDbContext
    {

        private readonly string _connectionString;

        public ApplicationDbContext(string connectionString)
        {
            _connectionString = connectionString;
        }

        public IDbConnection Connection
        {
            get
            {
                return new SqlConnection(_connectionString);
            }
        }
    }
}
