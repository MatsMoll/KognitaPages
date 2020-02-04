import BootstrapKit

extension Pages {

    public struct TermsOfService: HTMLPage {

        struct UsageSection: HTMLComponent {

            struct Context {
                let title: String
                let details: String
            }

            let title: HTML
            let details: HTML

            var body: HTML {
                Div {
                    Text {
                        title
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Text {
                        details
                    }
                    .text(color: .secondary)
                }
                .margin(.three, for: .top)
            }
        }

        public init() {}

        public var body: HTML {

            BaseTemplate(
                context: .init(title: "Brukervilkår", description: "Brukervilkår")
            ) {
                KognitaNavigationBar()
                Container {
                    Card {
                        Text {
                            "Brukervilkår"
                        }
                        .style(.heading2)
                        .text(color: .dark)

                        Small { "Sist endret: 09.01.2020" }

                        ForEach(in: policies) { policy in

                            UsageSection(
                                title: policy.title,
                                details: policy.details
                            )
                        }
                    }
                }
                .margin(.five, for: .vertical)
                KognitaFooter()
            }
        }

        let policies: [UsageSection.Context] = [
            .init(
                title: "1. Introduksjon",
                details: """
                kognita.no (heretter «Nettsiden») drives av AlphaDev, organisasjonsnummer 923022333 (heretter «Tjenestetilbyder»). På nettstedet kan du som bruker delta i et nasjonalt samfunn for kompetanseutvikling i enkeltemner ved universiteter. Tjenesten gir brukere tilgang til ulike utdaninngstjenester, slik som å øve på og lage innhold i forskjellige enkeltemner og utføre eksisterende eksamensoppgaver.
                Gjennom å ha tilgang til, besøke og bruke Tjenesten, samtykker du i de til enhver tid gjeldende brukervilkårene. Dersom du er under 15 år må du be en av dine foreldre eller foresatte om å gå igjennom disse vilkårene sammen med deg, slik at dere sammen kan godkjenne disse.
                Tjenestetilbyders kundeservice er tilgjengelig på: Kundeservice@Kognita.no.
                """
            ),
            .init(
                title: "2. Våre forpliktelser",
                details:  """
                Når du oppretter en bruker hos Tjenestetilbyder vil du deretter få tilgang til våre utdanningstjenester. Du kan til enhver tid logge deg inn på Nettsiden og få tilgang. Tjenesten har som mål å ha en oppetid på 99,9%, men Tjenestetilbyder gir ingen garantier knyttet til dette.
                Du kan når som helst velge å avslutte din tilgang til Tjenesten. Kontakt i så tilfelle vår kundeservice, som vil bistå deg å slette din brukerprofil.
                """
            ),
            .init(
                title: "3. Dine forpliktelser",
                details:  """
                Ved registrering bekrefter du at informasjonen som blir oppgitt er korrekt, fullstendig og du er selv ansvarlig for eventuelle feil i informasjonen.
                Tjenesten er for personlig bruk. Du kan ikke dele din innloggingsinformasjon med andre, videreselge eller utnytte tjenesten kommersielt. Det er ulovlig og straffbart å skaffe seg uautorisert tilgang til tjenesten, å kopiere innhold for annet enn privat bruk, samt å legge ut innhold fra Tjenesten på internett.
                Som bruker av Tjenesten er du ansvarlig for at ditt brukernavn og passord lagres og brukes på en trygg og sikker måte. Din innloggingsinformasjon er å regne som konfidensiell og må ikke overlates til uvedkommende. Du er ansvarlig for all aktivitet som foregår på Tjenesten med din innloggingsinformasjon.
                Dersom du mistenker at andre har fått tilgang til ditt brukernavn og passord må du kontakte oss uten ugrunnet opphold.
                Ved mistanke om brudd på Brukervilkårene, forbeholder Tjenestetilbyder seg retten til når som helst å stenge eller slette din profil.
                """
            ),
            // Unødvendig i pilot fasen
//            .init(
//                title: "4. Angrerett og refusjon",
//                details: """
//                Når du kjøper tilgang til tjenesten får du tilgang til de digitale tjenestene umiddelbart. Du samtykker til at leveringen påbegynnes umiddelbart og at du derfor ikke har angrerett på kjøpet, jf. angrerettlovens § 22 bokstav n.
//                Dersom det er noe galt med levering av tjenestene vil vi naturligvis ordne dette ved å utbedre problemet. Ved feil ber vi deg ta kontakt med oss på kundeservice raskest mulig slik at vi kan løse problemet
//                """
//            ),
            .init(
                title: "4. Immaterielle rettigheter",
                details: """
                Tjenestetilbyder innehar alle immaterielle rettigheter knyttet til alt materiale som er tilgjengelig på Nettsidene og i Tjenesten, samt til det materialet som sendes i form av flyers, videoer, e-post, dokumenter, plakater med mer. Hel eller delvis referanse til, eller gjengivelse av, materiale tilhørende Tjenestetilbyder kan kun finne sted etter uttrykkelig skriftlig tillatelse. Det presiseres at materialet du mottar er for ditt personlige bruk og er beskyttet av lov om opphavsrett. Det er ikke tillatt å kopiere, distribuere, fremvise, publisere eller selge informasjon, programvare, produkter eller tjenester som gjøres tilgjengelig Nettsidene. Unntak gjøres for utskrift for særskilt personlig bruk.
                Anvendelse av varemerket og logotyper som forekommer på Nettsiden og ellers i Tjenesten forutsetter forutgående skriftlige samtykke fra Tjenestetilbyder.
                Eventuelle krenkelser av immaterielle rettigheter kan medføre erstatningsansvar eller straffansvar etter norsk lov og vil bli forfulgt ved søksmål eller anmeldelse.
                """
            ),
            .init(
                title: "5. Kommunikasjon",
                details: """
                Etter registrering kan Tjenestetilbyder kontakte deg på e-post med informasjon vedrørende ditt kundeforhold eller med markedsføring for Tjenestetilbyders tjenester. Om du ikke lenger ønsker å motta epost fra oss, kan du melde deg av vårt nyhetsbrev ved å trykke på lenken i slutten av eposten eller ved å kontakte vår kundeservice.
                Din e-postadresse vil bli behandlet konfidensielt og aldri bli solgt til, eller på andre måter tilgjengeliggjort for, tredjeparter.
                """
            ),
            .init(
                title: "6. Behandling av personlig informasjon",
                details:  """
                Tjenesten behandler personopplysninger i samsvar med til enhver tid relevante lover og i henhold til sin Personvernerklæring. Personvernerklæringen er tilgjengeliggjort på Tjenestens nettsider og er en integrert del av disse Brukervilkårene.
                """
            ),
            .init(
                title: "7. Erstatning og ansvarsfraskrivelse",
                details: """
                Tjenestene og informasjonen som gjøres tilgjengelig via Tjenesten tilbys “som det er” uten noen garantier. Tjenestetilbyder garanterer ikke at den informasjon som er tilgjengelig på Nettsiden og i Tjenesten ellers er korrekt eller fullstendig.
                Tjenestetilbyder og dens samarbeidspartnere kan ikke under noen omstendighet holdes ansvarlig for skader på ting, tap av data, tapt fortjeneste eller noe annet tap eller kostnad som kan oppstå i forbindelse med bruk av tjenesten, eller som følge av manglende leveranse av tjenesten.
                """
            ),
            .init(
                title: "8. Endringer av avtalen",
                details: """
                Tjenestetilbyder forbeholder seg til enhver tid retten til å endre eller erstatte disse Brukervilkårene. Oppdaterte brukervilkår vil bli gjort tilgjengelig på Tjenestetilbyders nettsider. Som bruker er det ditt ansvar å gjøre deg kjent med Brukervilkårene.
                Ved fortsatt bruk av Tjenesten etter at endringene i Brukervilkårene er gjort tilgjengelig godtar du å være bundet av de oppdaterte Brukervilkårene. Dersom du ikke godtar de nye vilkårene må du slutte å bruke tjenesten. Kontakt i så tilfelle kundeservice for å slette din brukerprofil.
                """
            ),
            .init(
                title: "9. Verneting",
                details: """
                Disse vilkårene skal tolkes i samsvar med norsk lov. Asker og Bærum tingrett er Tjenestetilbyders ordinære verneting.
                """
            )
        ]
    }
}
