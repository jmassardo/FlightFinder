$pkg_name="FlightFinder"
$pkg_origin="jmassardo"
$pkg_version="0.1.0"
$pkg_maintainer="James Massardo <jmassardo@chef.io>"
$pkg_license=@("Apache-2.0")

$pkg_deps=@("core/dotnet-asp-core")
$pkg_build_deps=@("core/dotnet-core-sdk")

function Invoke-Unpack {
  # Copy the source code into the Habitat cleanroom for the build
  Copy-Item $PLAN_CONTEXT\..\FlightFinder.sln $HAB_CACHE_SRC_PATH -Recurse -Force
  Copy-Item $PLAN_CONTEXT\..\FlightFinder.Client $HAB_CACHE_SRC_PATH -Recurse -Force
  Copy-Item $PLAN_CONTEXT\..\FlightFinder.Server $HAB_CACHE_SRC_PATH -Recurse -Force
  Copy-Item $PLAN_CONTEXT\..\FlightFinder.Shared $HAB_CACHE_SRC_PATH -Recurse -Force
}

function Invoke-Build {
  # Perform build
  dotnet restore $HAB_CACHE_SRC_PATH\FlightFinder.sln
  dotnet build $HAB_CACHE_SRC_PATH\FlightFinder.sln

  # Let's double check that our build was successful
  if($LASTEXITCODE -ne 0) {
      Write-Error "dotnet build failed!"
  }
}

function Invoke-Install {
  # Lastly, let's publish our projects into a location that is captured when the Habitat artifact is created.
  dotnet publish $HAB_CACHE_SRC_PATH\FlightFinder.Client\FlightFinder.Client.csproj --output "$pkg_prefix/www"
  dotnet publish $HAB_CACHE_SRC_PATH\FlightFinder.Server\FlightFinder.Server.csproj --output "$pkg_prefix/www"
  dotnet publish $HAB_CACHE_SRC_PATH\FlightFinder.Shared\FlightFinder.Shared.csproj --output "$pkg_prefix/www"
}
