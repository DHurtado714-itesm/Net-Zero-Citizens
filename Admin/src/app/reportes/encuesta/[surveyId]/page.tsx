import { fetchSurveyReport, QuestionReport, tabulatedAns } from '@/api/report'
import ScaleChart from './components/ScaleChart'

type SurveyReportProps = {
  params: {
    surveyId: string
  }
}

export default async function SurveyReport(props: SurveyReportProps) {
  try {
    const surveyId = props.params.surveyId
    const surveyReport = await fetchSurveyReport(surveyId)

    return (
      <div>
        <h1 className="text-black text-5xl font-extrabold p-10">
          {surveyReport.title}
        </h1>
        {[
          surveyReport.questions.map((question, index) => {
            const labels = question.answers?.map((answer) => answer.label)
            const data = question.answers?.map((answer) => answer.count)
            return (
              <div className="flex">
                <div className="pl-20 w-1/2">
                  <QuestionComponent key={index} {...question} />
                  <h3 className="text-black font-extrabold text-3xl pt-64 pb-2">
                    Total de respuestas
                  </h3>
                  <div className="bg-zinc-900 text-white rounded-full text-xl font-semibold p-2 px-4 inline-block">
                    {question.answers
                      .map((ans) => ans.count)
                      .reduce((prev, curr) => (prev += curr))}
                  </div>
                </div>
                <div className="pt-20 w-1/2">
                  <h2 className="text-black font-extrabold text-4xl">
                    Desglose de respuestas
                  </h2>
                  <div className="w-3/4">
                    {question.questionType != 'open' && (
                      <ScaleChart
                        {...{
                          title: question.questionText,
                          labels,
                          data,
                        }}
                      />
                    )}
                  </div>
                </div>
              </div>
            )
          }),
        ]}
      </div>
    )
  } catch (e: unknown) {
    if (e instanceof Error) {
      return <div>{e.message}</div>
    } else {
      return <div>Unknown error</div>
    }
  }
}

const questionTypeMap = {
  scale: 'Escala',
  open: 'Abierta',
  multiple_choice: 'Opción Múltiple',
}

function QuestionComponent(props: QuestionReport) {
  return (
    <div className="text-txt bg-background">
      <h3 className="text-txt font-medium">{props.questionText}</h3>
      <h3 className="text-black font-extrabold text-3xl pt-10 pb-3">
        Tipo de pregunta
      </h3>
      <div className="bg-emerald-600 text-white font-semibold rounded-lg text-sm px-6 py-2 inline-block">
        {questionTypeMap[props.questionType]}
      </div>
      {props.questionType == 'open' &&
        props.answers?.map((answer, index) => {
          return <AnswerComponent key={index} {...answer} />
        })}
    </div>
  )
}

function AnswerComponent(props: tabulatedAns) {
  return (
    <div>
      <h3>{props.label}</h3>
      <p>{props.count}</p>
    </div>
  )
}
