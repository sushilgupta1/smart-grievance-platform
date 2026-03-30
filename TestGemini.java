import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class TestGemini {
    public static void main(String[] args) throws Exception {
        String key = "AIzaSyB0sGfm1JiVWdA-yBKVu1xzn9RO5LNXHm0";
        String urlString = "https://generativelanguage.googleapis.com/v1beta/models?key=" + key;
        
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(urlString))
                .GET()
                .build();
                
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        System.out.println("STATUS: " + response.statusCode());
        System.out.println("BODY: " + response.body());
    }
}
