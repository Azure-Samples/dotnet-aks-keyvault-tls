using System.Security.Cryptography.X509Certificates;

var builder = WebApplication.CreateBuilder(args);

string cert = builder.Configuration["CERTIFICATE_PATH"] ?? throw new ArgumentNullException("CERTIFICATE_PATH");
string key =  builder.Configuration["CERTIFICATE_KEY_PATH"] ?? throw new ArgumentNullException("CERTIFICATE_KEY_PATH");

builder.WebHost.UseKestrel(
    o => o.ConfigureHttpsDefaults(
        l => l.ServerCertificate = X509Certificate2.CreateFromPemFile(cert, key)));

var app = builder.Build();
app.UseHttpsRedirection();
app.MapGet("/", (string? name) => $"Hello {name ?? "world"}!");
app.Run();