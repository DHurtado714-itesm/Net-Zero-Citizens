package com.greencircle

import com.google.gson.Gson
import com.google.gson.JsonSyntaxException
import com.greencircle.domain.model.survey.Question
import com.greencircle.domain.model.survey.QuestionOption
import com.greencircle.domain.model.survey.QuestionType
import org.junit.Assert.assertNull
import org.junit.Assert.assertThrows
import org.junit.Test

/**
 * Pruebas unitarias para la clase Question
 */
class QuestionTest {
    /**
     * Prueba que se pueda crear una pregunta válida
     */
    @Test
    fun validQuestion() {
        val json = """
            {
                "questionId": "testId",
                "questionText": "testText",
                "questionType": "multiple_choice",
                "questionOptions": [
                    {
                        "questionOptionId": "testOption1",
                        "textOption": "testOption1"
                    },
                    {
                        "questionOptionId": "testOption2",
                        "textOption": "testOption2"
                    }
                ]
            }
        """.trimIndent()

        val question = Gson().fromJson(json, Question::class.java)

        assert(question.questionId == "testId")
        assert(question.questionText == "testText")
        assert(question.questionType == QuestionType.multiple_choice)
        assert(
            question.questionOptions == listOf(
                QuestionOption("testOption1", "testOption1"),
                QuestionOption("testOption2", "testOption2"),
            ),
        )
    }

    /**
     * Prueba que un valor invalido en questionType genere un valor nulo
     */
    @Test
    fun invalidQuestionData() {
        val json = """
            {
                "questionId": "testId",
                "questionText": "testText",
                "questionType": "No es un tipo",
                "questionOptions": [
                    {
                        "questionOptionId": "testOption1",
                        "textOption": "testOption1"
                    },
                    {
                        "questionOptionId": "testOption2",
                        "textOption": "testOption2"
                    }
                ]
            }
        """.trimIndent()

        val question = Gson().fromJson(json, Question::class.java)
        assertNull(question.questionType)
    }

    /**
     * Prueba que un json invalido genere una excepción
     */
    @Test
    fun invalidQuestionJson() {
        val json = """
                "questionId": "testId",
                "questionText": "testText",
                "questionType": "No es un tipo",
                "questionOptions": [
                    {
                        "questionOptionId": "testOption1",
                        "textOption": "testOption1"
                    },
                    {
                        "questionOptionId": "testOption2",
                        "textOption": "testOption2"
                    }
                ]
        """.trimIndent()

        assertThrows(JsonSyntaxException::class.java) {
            Gson().fromJson(json, Question::class.java)
        }
    }
}
