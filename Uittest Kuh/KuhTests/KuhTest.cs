using System.IO;
using Xunit;

public class KuhTests
{
    [Theory]
    [InlineData(null)]
    [InlineData("")]
    public void Constructor_NameIsNullOrEmpty_ThrowsInvalidDataException(string invalidName)
    {
        // Act & Assert: Prüft, ob beim Aufruf des Konstruktors eine InvalidDataException geworfen wird
        Assert.Throws<InvalidDataException>(() => new Kuh(invalidName, "Braun"));
    }

    [Fact]
    public void Constructor_ValidInputs_CreatesKuhObject()
    {
        // Arrange
        string validName = "Berta";
        string validColour = "Schwarz-Weiß";

        // Act
        var kuh = new Kuh(validName, validColour);

        // Assert
        Assert.Equal(validName, kuh.Name);
        Assert.Equal(validColour, kuh.Colour);
    }
}