using Dapper;
using devtest.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace devtest.Pages
{
    public class IndexModel : PageModel
    {
        private readonly IConfiguration _configuration;

        public IndexModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public List<TeamStats> TeamStatistics { get; set; }

        public void OnGet()
        {
            

            string connectionString = _configuration.GetConnectionString("DefaultConnection");

            if (string.IsNullOrEmpty(connectionString))
            {
                throw new ApplicationException("Connection string is null or empty.");
            }

            try
            {
                using (IDbConnection dbConnection = new SqlConnection(connectionString))
                {
                    dbConnection.Open();

                    // Execute the stored procedure and map the results to the model class
                    TeamStatistics = dbConnection.Query<TeamStats>("GetAllTeamsStatsWithUrl", commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (Exception ex)
            {
                // Handle any exceptions here, e.g., log the error or display a user-friendly message.
                throw new ApplicationException("An error occurred while accessing the database.", ex);
            }

        }
    }
}