using System.Net;
using System.Text.Json;
using System.Text.Json.Serialization;

var client = new HttpClient();
string content = await client.GetStringAsync("https://swapi.dev/api/people/1");

Person luke = JsonSerializer.Deserialize<Person>(content, SourceGenerationContext.Default.Person)!;

Console.WriteLine("{0} has {1} eyes",luke.name, luke.eyeColor);

public class Person {
    public string? name {get; set;}

    [JsonPropertyName("eye_color")]
    public string? eyeColor {get; set;}
}
// needed to get json serialization working with trimming, see the following:
// https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/source-generation
[JsonSerializable(typeof(Person))]
internal partial class SourceGenerationContext : JsonSerializerContext{}