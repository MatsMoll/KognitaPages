import BootstrapKit


extension Pages {
    public struct PrivacyPolicy: HTMLPage {

        struct PolicySection: HTMLComponent {

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
                context: .init(title: "Personværn", description: "Personværn")
            ) {
                KognitaNavigationBar()
                Container {
                    Card {
                        Text {
                            "Personvernerklæring for kognita.no"
                        }
                        .style(.heading2)
                        .text(color: .dark)

                        Text { introText }
                            .text(color: .secondary)

                        ForEach(in: policies) { policy in

                            PolicySection(
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

        let introText: String = """
        Denne personvernerklæringen omhandler AlphaDev AS’ innsamling og bruk av personopplysninger som samles inn i forbindelse med bruk av nettsiden uni.kognita.no eller ved registrering av bruker på uni.kognita.no.
        AlphaDev AS er behandlingsansvarlig for opplysningene som samles inn ved bruk av uni.kognita.no.
        I denne personvernerklæringen finner du informasjon om hvilke personopplysninger som samles inn, hvorfor vi gjør dette og dine rettigheter knyttet til behandlingen av personopplysningene. Denne erklæringen vil kunne være gjenstand for oppdateringer og endringer.
        """

        let policies: [PolicySection.Context] = [
            .init(
                title: "1. Hvilke opplysninger behandles og hvordan brukes opplysningene",
                details: """
                Vi samler inn og bruker dine personopplysninger til ulike formål avhengig av hvem du er og hvordan vi kommer i kontakt med deg. Vi behandler personopplysninger som leverandør av tjenester, i markedsføringsøyemed og i forbindelse med besøk på vår hjemmeside, uni.kognita.no.
                Opplysninger du selv oppgir
                Ved registrering og senere i kundeforholdet samler inn opplysninger og vurderinger som kan knyttes til en enkeltperson. Som eksempel kan nevnes navn, adresse, telefonnummer og e-postadresse
                I tillegg kan vi samle annen informasjon knyttet til din bruk av vårt nettsted, herunder relevant statistikk.
                Opplysninger vi samler inn om din bruk av kognita.no
                AlphaDev AS loggfører din aktivitet i tjenesten, herunder når du logget inn, antall innlogginger, hvordan du bruker våre tjenester, m. m. og oppbevarer den på våre servere.
                Informasjonskapsler
                Informasjonskapsler («cookies») er små tekstfiler som plasseres på din datamaskin, mobiltelefon eller nettbrett når du laster ned en nettside. Informasjonskapslene kan eksempelvis inneholde brukerinnstillinger og informasjon om hvordan du har surfet på og brukt vår nettside, hvilken nettleser du bruker og lignende.
                Vi benytter forskjellige typer informasjonskapsler på kognita.no. Disse kan deles inn i følgende kategorier:
                ●    Vi bruker informasjonskapsler for å forbedre nettstedet og forenkle din brukeropplevelse.
                ●    Vi bruker informasjonskapsler fra tredjepartsverktøy for analyse og statistikk.
                ●    Vi bruker informasjonskapsler fra ulike annnonseringsplattformer, for å øke effektiviteten av vår digitale markedsføring og spore brukerregistreringer.
                Dersom du ikke ønsker at vi skal benytte informasjonskapsler til å samle inn data, så kan du endre sikkerhetsinnstillingene for informasjonskapsler på din datamaskin, mobiltelefon eller nettbrett.
                """
            ),
            .init(
                title: "2. Formålet med innhenting av informasjonen",
                details:  """
                Personopplysningene innhentes og behandles for å kunne oppfylle en avtale med deg som bruker eller etter en interesseavveining. Dersom du har akseptert å motta markedsføring på e-post bruker vi informasjonen for å sende deg nyhetsbrev, herunder brukertilpassede og relevante kampanjer. I tillegg bruker vi informasjonen til å forbedre vår tjeneste og sørge for at den videreutvikles på en tilfredsstillende måte, samt til statistiske formål for eget og samarbeidspartneres bruk.
                """
            ),
            .init(
                title: "3. Rettslig grunnlag for behandling av personopplysninger",
                details:  """
                Det rettslige grunnlaget for AlphaDev AS’ behandling av personopplysninger er ditt samtykke til denne personvernerklæring, og brukervilkårene for øvrig, jf. GDPR art 6 nr 1 a). Samtykket er avgitt informert, aktivt og frivillig.
                Ved at du klikker på knappen ved siden av personvernerklæringen under registreringsprosessen, samtykker du til vår behandling av dine opplysninger. Dette samtykket kan fritt trekkes tilbake ved å ta kontakt med oss. Du finner vår kontaktinformasjon under punkt 9 i denne personvernerklæring.
                """
            ),
            .init(
                title: "4. Hvem får tilgang til opplysningene/utlevering",
                details: """
                Vi gir ikke personopplysningene dine videre til andre med mindre det foreligger et lovlig grunnlag for slik utlevering. Eksempler på slikt grunnlag vil typisk være en avtale med deg eller et lovgrunnlag som pålegger oss å gi ut informasjonen.
                Informasjonen du avgir til AlphaDev AS kan deles med følgende type virksomheter:
                ●    Tekniske tjenesteleverandører, slik som leverandører for systemer innen kundeservice, analyseverktøy innen markedsføring, kundedialogverktøy, m.v.
                ●    Markedsføringspartnere, eksempelvis for utsending av nyhetsbrev eller sporing og målretting av reklame.
                Disse virksomhetene anvender personopplysningene innenfor formålet angitt i punkt 2 i denne personvernerklæringen. Virksomhetene er underlagt egne databehandleravtaler inngått med AlphaDev AS.
                All behandling av personopplysninger som vi foretar er i samsvar med personvernlovgivningen.
                """
            ),
            .init(
                title: "5. Rutiner for arkivering og sletting",
                details: """
                Vi lagrer dine personopplysninger hos oss så lenge det er nødvendig for det formål personopplysningene ble samlet inn for.
                Dette betyr for eksempel at personopplysninger som vi behandler på grunnlag av ditt samtykke slettes hvis du trekker ditt samtykke. Personopplysninger vi behandler for å oppfylle en avtale med deg slettes når avtalen er oppfylt og alle plikter som følger av avtaleforholdet er oppfylt. Noen opplysninger har vi lovmessig plikt til å oppbevare i en viss periode, som f eks regnskapsmateriale. Opplysningene slettes da når fristen for oppbevaringsplikten har utløpt.
                """
            ),
            .init(
                title: "6. Hvordan oppbevares og sikres opplysningene",
                details: """
                AlphaDev AS setter sine kunders personvern høyt og vil forsikre om at deres personvern ivaretas i overensstemmelse med de krav som stilles i gjeldende lovgivning.
                Herunder forsikrer AlphaDev AS at opplysningene lagres på en sikker måte i henhold til enhver tids gjeldende personvernlovgivning, samt at opplysningene ikke vil komme uvedkommende til kunnskap. I forlengelsen forsikrer AlphaDev AS at opplysningene er lagret i systemer som har den nødvendige informasjonssikkerhet med hensyn til konfidensialitet, integritet og tilgjengelighet.
                AlphaDev AS sine ansatte og tilknyttede avtaleparter er forpliktet til å følge de lover, forskrifter og interne retningslinjer som gjelder for behandling av personopplysninger.
                """
            ),
            .init(
                title: "7. Dine rettigheter som registrert bruker",
                details:  """
                Du har rett til å kreve innsyn, retting eller sletting av personopplysningene vi behandler om deg. Du har videre rett til å kreve begrenset behandling, rette innsigelse mot behandlingen og kreve rett til dataportabilitet. Du kan lese mer om innholdet i disse rettighetene på Datatilsynets nettside: www.datatilsynet.no.
                For å ta i bruk dine rettigheter må du ta skriftlig kontakt med oss. Vi vil svare på din henvendelse til oss så fort som mulig.
                Vi vil kunne be deg om å bekrefte identiteten din eller å oppgi ytterligere informasjon før vi lar deg ta i bruk dine rettigheter overfor oss. Dette gjør vi for å være sikre på at vi kun gir tilgang til dine personopplysninger til deg - og ikke noen som gir seg ut for å være deg.
                Du kan til enhver tid trekke tilbake ditt samtykke, dersom du har avgitt dette, for behandling av personopplysninger hos oss. Den enkleste måten å gjøre dette på, er å ta skriftlig kontakt med oss på kundeservice@kognita.no.
                Dersom du mener at vår behandling av personopplysninger ikke stemmer med det vi har beskrevet her eller at vi på andre måter bryter personvernlovgivningen, så kan du klage til Datatilsynet.
                Du finner informasjon om hvordan kontakte Datatilsynet på Datatilsynets nettsider: www.datatilsynet.no.
                """
            ),
            .init(
                title: "8. Endringer",
                details: """
                Hvis det skulle skje endring av våre tjenester eller endringer i regelverket om behandling av personopplysninger, kan det medføre forandring i informasjonen du er gitt her. Slike endringer vil kommuniseres per e-post, samt ved at en oppdatert versjon av personvernerklæringen legges ut på selskapets nettsider.
                """
            ),
            .init(
                title: "9. Kontaktinformasjon",
                details: """
                Du kan når som helst stille oss spørsmål om hvordan vi behandler dine brukerdata og gjøre dine ovennevnte rettigheter gjeldende, ved å kontakte vår Kundeservice på e- post: kundeservice@kognita.no.
                """
            )
        ]
    }
}
