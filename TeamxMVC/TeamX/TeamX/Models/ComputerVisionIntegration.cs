using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

public static class ComputerVisionIntegration
{
    /// <summary>
    /// Gets a thumbnail image from the specified image file by using the Computer Vision REST API.
    /// </summary>
    /// <param name="imageFilePath">The image file to use to create the thumbnail image.</param>
    static async Task<string> MakeAnalysisRequest(string imageFilePath)
    {
        var subscriptionKey = "3dc8896da7c64d238d3dc3402aaeb697";
        HttpClient client = new HttpClient();

        // Request headers.
        client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", subscriptionKey);

        // Request parameters. Change "landmarks" to "celebrities" here and in uriBase to use the Celebrities model.
        string requestParameters = "model=landmarks";

        // Assemble the URI for the REST API Call.
        string uri = "https://eastus.api.cognitive.microsoft.com/vision/v1.0" + "?" + requestParameters;

        HttpResponseMessage response;

        // Request body. Posts a locally stored JPEG image.
        byte[] byteData = GetImageAsByteArray("\\Content\\img\\car accident.jpg");

        using (ByteArrayContent content = new ByteArrayContent(byteData))
        {
            // This example uses content type "application/octet-stream".
            // The other content types you can use are "application/json" and "multipart/form-data".
            content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");

            // Execute the REST API call.
            response = await client.PostAsync(uri, content);

            // Get the JSON response.
            return await response.Content.ReadAsStringAsync();
        }
    }

    /// <summary>
    /// Returns the contents of the specified file as a byte array.
    /// </summary>
    /// <param name="imageFilePath">The image file to read.</param>
    /// <returns>The byte array of the image data.</returns>
    static byte[] GetImageAsByteArray(string imageFilePath)
    {
        FileStream fileStream = new FileStream(imageFilePath, FileMode.Open, FileAccess.Read);
        BinaryReader binaryReader = new BinaryReader(fileStream);
        return binaryReader.ReadBytes((int)fileStream.Length);
    }
}