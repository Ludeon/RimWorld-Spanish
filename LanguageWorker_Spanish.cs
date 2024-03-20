public class LanguageWorker_Spanish : LanguageWorker
{
    public override string WithIndefiniteArticle(string str, Gender gender, bool plural = false, bool name = false)
    {
        //Names don't get articles
        if( name )
            return str;

        return (gender == Gender.Female ? "una " : "un ") + str;
    }

    public override string WithDefiniteArticle(string str, Gender gender, bool plural = false, bool name = false)
    {
        //Names don't get articles
        if( name )
            return str;

        return (gender == Gender.Female ? "la " : "el ") + str;
    }

    public override string OrdinalNumber(int number, Gender gender = Gender.None)
    {
        return number + ".º";
    }
    
    public override string Pluralize(string str, Gender gender, int count = -1)
    {
        if( str.NullOrEmpty() )
            return str;
        
        char last = str[str.Length - 1];
        char oneBeforeLast = str.Length >= 2 ? str[str.Length - 2] : '\0';

        if( IsVowel(last) )
        {
            if( str == "sí" )
                return "síes";
            else if( last == 'í' || last == 'ú' || last == 'Í' || last == 'Ú' )
                return str + "es";
            else
                return str + 's';
        }
        else
        {
            if( (last == 'y' || last == 'Y') && IsVowel(oneBeforeLast) )
                return str + "es";
            else if( "lrndzjsxLRNDZJSX".IndexOf(last) >= 0 || (last == 'h' && oneBeforeLast == 'c') )
                return str + "es";
            else
                return str + 's';
        }
    }

    public bool IsVowel(char ch)
    {
        return "aeiouáéíóúAEIOUÁÉÍÓÚ".IndexOf(ch) >= 0;
    }
}