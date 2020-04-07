using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VueWebForms
{
    public partial class RouterWithServerData : System.Web.UI.Page
    {
        static List<SampleDataModel> sampleData = new List<SampleDataModel>
        {
            new SampleDataModel{ Id = 1, Title="Item 1", Description = "Description 1" },
            new SampleDataModel {Id =2, Title="Item 2", Description= "Description 2" },
            new SampleDataModel {Id=3, Title="Item 3", Description="Description 3" }
        };

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetData()
        {
            return sampleData;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static SampleDataModel CreateItem(SampleDataModel data)
        {
            // Figure out a new ID of course
            var lastIdentifier = sampleData.OrderBy(x => x.Id).LastOrDefault();

            if (lastIdentifier == null)
            {
                data.Id = 1;
            }
            else
            {
                data.Id = lastIdentifier.Id + 1;
            }

            sampleData.Add(data);

            return data;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static bool UpdateItem(SampleDataModel data)
        {
            bool result = false;

            if (data != null)
            {
                var updateObject = sampleData.FirstOrDefault(x => x.Id == data.Id);
                if (updateObject != null)
                {
                    updateObject.Title = data.Title;
                    updateObject.Description = data.Description;
                    result = true;
                }
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static bool DeleteItem(DeleteRequestObject data)
        {
            var deletedCount = sampleData.RemoveAll(x => x.Id == data.Id);
            return deletedCount > 0;
        }
    }

    public class SampleDataModel
    {
        static int idGenerator = 1;

        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
    }

    public class DeleteRequestObject
    {
        public int Id { get; set; }
    }
}